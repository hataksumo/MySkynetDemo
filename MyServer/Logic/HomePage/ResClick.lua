function PLAYER_REQUEST.GatherRes(v_tMsg)
	local cfg_clickResInfo = sharetable.query("cfg_clickResInfo")
	local cfg_global = sharetable.query("cfg_global")
	local iSlot = v_tMsg.slot
	local iniIds = cfg_global.clickInfo_res_iniIds
	local theClickResInfo = cfg_clickResInfo[iniIds[iSlot]]
	g_player:UpdateClickInfo()
	local iUsed = g_player:UseResClick(iSlot,v_tMsg.clickTimes)
	local arrAddRes = {}
	for _i,data in ipairs(theClickResInfo.ClickAward) do
		table.insert(arrAddRes,{id = data.Id,val = data.Val * iUsed})
	end
	g_player:AddItems(arrAddRes)
	sendMsg(40040,{slot = iSlot,clickResInfo = g_player:GetClickResInfo(iSlot)})
end