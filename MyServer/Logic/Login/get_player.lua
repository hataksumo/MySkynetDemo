MAX_ACCOUNT_PLAYER = 1


function ACCOUNT_REQUEST.PullPlayerList(v_tMsg)
	--print("ACCOUNT_REQUEST.PullPlayerList v_tMsg.account_id = "..v_tMsg.account_id)
	if not v_tMsg.account_id then
		print("ACCOUNT_REQUEST.PullPlayerList = nil")
		return
	end
	local ok,res = skynet.call(".sql","lua","Querycb","GetPlayerList",{v_tMsg.account_id})
	local idList = {}
	--print("res = "..print_table(res))
	for _i,val in ipairs(res) do
		table.insert(idList,val.uid)--uid
	end
	--print("len idList = "..#idList)
	sendMsg(40030,{player_idlist = idList})
end

function ACCOUNT_REQUEST.PullPlayerInfo(v_tMsg)
	--print("PullPlayerInfo "..v_tMsg.uid)
	local ok,rst = skynet.call(".sql","lua","Querycb","GetPlayerInfo",{v_tMsg.uid})
	if rst then
		g_player = Player:new()
		g_player:InitWithSelectRst(v_tMsg.uid,rst)
		g_player:UpdateTimestamp()
		g_player:AutoSave()
		local s2cMsgs = {
			code = 1,
			player_id = v_uid,
			usr_name = rst.nick_name,
			db_city_info = rst.city_info,
			db_resbag_info = rst.resbag_info,
			view_city_info = {
				days = g_player:GetDays(),
				clickRes = {
				}
			}
		}
		for _slot =1,3 do
			s2cMsgs.view_city_info.clickRes[_slot] = g_player:GetClickResInfo(_slot)
		end
		sendMsg(40031,s2cMsgs)

	else
		sendMsg(40031,{code = 2})
	end
end

function ACCOUNT_REQUEST.NewPlayer(v_tMsg)
	local tmpPlayer = Player:new()
	tmpPlayer:InitWithDefault()
	--print("nickName = "..(v_tMsg.nickName or "nil"))
	local ok,res = skynet.call(".sql","lua","Querycb","GetAccountPlayerCnt",{g_account.uid})
	if res.cnt > MAX_ACCOUNT_PLAYER then
		--print("sendMsg(40032,{code = 4})")
		sendMsg(40032,{code = 4})
		return
	end
	local ok,res = skynet.call(".sql","lua","Querycb","HasPlayerNickName",{v_tMsg.nickName})
	if res.cnt >= 1 then
		--print("sendMsg(40032,{code = 2})")
		sendMsg(40032,{code = 2})
		return
	end
	if not tmpPlayer:NewSave(v_tMsg.nickName) then
		sendMsg(40032,{code = 5})
		return
	end
	ACCOUNT_REQUEST.PullPlayerList({account_id = g_account.uid})
end
