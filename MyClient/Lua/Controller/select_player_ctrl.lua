local SelectPlayerCtrl = class(CtrlBase)
function SelectPlayerCtrl:Ctor()
	self:AddSocketListener(40030,self.OnNetPullPlayerList)
	self:AddSocketListener(40032,self.OnNetNewPlayer)
	self:AddSocketListener(40031,self.OnNetPullPlayerInfo)
	self.CMDS["EnsureNickName"] = self.OnCmdEnsureNickName
end

function SelectPlayerCtrl:Start()
	--print("SelectPlayerCtrl:Start account_id = "..gAccount.GetUid())
	ViewMgr.HideAll()
	Network.SendMsg(10030,{account_id = gAccount.GetUid()})
end

function SelectPlayerCtrl:OnNetPullPlayerList(v_tMsg)
	--print("SelectPlayerCtrl:OnNetPullPlayerList")
	if #(v_tMsg.player_idlist) > 0 then
		print("player_id = "..v_tMsg.player_idlist[1])
		self:SelectPlayer(v_tMsg.player_idlist[1])
	else
		--弹出昵称设置窗口
		self:ShowUniqueView("SetNickName")
	end
end

function SelectPlayerCtrl:SelectPlayer(v_iPlayerId)
	Network.SendMsg(10031,{uid = v_iPlayerId})
end

function SelectPlayerCtrl:OnCmdEnsureNickName(v_oSender,v_sNickName)
	self:EnsureNickName(v_sNickName)
end

function SelectPlayerCtrl:EnsureNickName(v_sNickName)
	--print("nick name is "..v_sNickName)
	Network.SendMsg(10032,{nickName = v_sNickName})
end

function SelectPlayerCtrl:OnNetNewPlayer(v_tMsg)
	if v_tMsg.code == 1 then
		--等待服务器发来用户信息
		Network.BeginRequest()
		ViewMgr.HideView("SetNickName")
	elseif v_tMsg.code == 2 then
		self:SendViewMsg("SetNickName","Warning",10009)
	elseif v_tMsg.code == 3 then
		self:SendViewMsg("SetNickName","Warning",10011)
	elseif v_tMsg.code == 4 then
		self:SendViewMsg("SetNickName","Warning",10012)
	elseif v_tMsg.code == 5 then
		self:SendViewMsg("SetNickName","Warning",10012)
	end
	print("okok")
end

function SelectPlayerCtrl:OnNetPullPlayerInfo(v_tMsg)
	if v_tMsg.code == 2 then
		self:SendViewMsg("SetNickName","Warning",10013)
		return
	end
	gPlayer = Player:new()
	gPlayer:SetUid(v_tMsg.player_id)
	gPlayer:InitWithPull(v_tMsg)
	local homePageCtrl = CtrlMgr.GetOrCreateCtrl("HomePage")
	homePageCtrl:Start()
	--self:Exit()
end

return SelectPlayerCtrl