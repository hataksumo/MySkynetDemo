local MsgHandler = {}

local function unpackMsg(v_iIdx,v_iType,v_iMsgId,v_sMsgData)
	local cfg_msg = sharetable.query("cfg_msg")
	local tMsg = nil
	local KeyIdx = {[1] = "C2S", [2] = "S2C"}
	local idkey = KeyIdx[v_iIdx]
	local the_msg_cfg = cfg_msg[idkey][v_iMsgId]
	--print("v_sMsgData = "..v_sMsgData or "nil")
	--print("v_sMsgData : "..string.printByte(v_sMsgData))
	if the_msg_cfg then
		if not ProtoSchema:exist_type(the_msg_cfg.ProtoName) then
			print("don't have the ProtoName"..the_msg_cfg.ProtoName)
			return nil
		end
		tMsg = ProtoSchema:decode(the_msg_cfg.ProtoName,v_sMsgData)
	else
		print(string.format("cfg_msg[%s][%d] = nil",idkey,v_iMsgId))
		return
	end
	--print("unpackMsg : ".. print_table(tMsg) )
	if not the_msg_cfg.SrvReqHandler then
		print("the_msg_cfg.SrvReqHandler = nil "..print_table(the_msg_cfg))
	end
	return {tMsg = tMsg,handler = the_msg_cfg.SrvReqHandler}
end

local function packMsg(v_iIdx,v_iType,v_iMsgId,v_tMsgData)
	local cfg_msg = sharetable.query("cfg_msg")
	local sMsg = nil
	local KeyIdx = {[1] = "C2S", [2] = "S2C"}
	local idkey = KeyIdx[v_iIdx]
	local the_msg_cfg = cfg_msg[idkey][v_iMsgId]

	if the_msg_cfg then
		if not ProtoSchema:exist_type(the_msg_cfg.ProtoName) then
			print("don't have the ProtoName"..the_msg_cfg.ProtoName)
			return nil
		end
		sMsg = ProtoSchema:encode(the_msg_cfg.ProtoName,v_tMsgData)
	else
		print(string.format("cfg_msg[\"%s\"][%d] = nil",idkey,v_iMsgId))
	end
	if not sMsg then
		return false
	end
	local sPack = string.pack("<HHHs2",string.len(sMsg)+6,v_iType,v_iMsgId,sMsg)
	return sPack
end

function MsgHandler.unpackC2SMsg(v_tCfg)
	return unpackMsg(1,v_tCfg.iMsgType,v_tCfg.iMsgId,v_tCfg.sMsg)
end

function MsgHandler.unpackS2CMsg(v_tCfg)
	return unpackMsg(2,v_tCfg.iMsgType,v_tCfg.iMsgId,v_tCfg.sMsg)
end

function MsgHandler.packS2CMsg(v_tCfg)
	return packMsg(2,v_tCfg.iMsgType,v_tCfg.iMsgId,v_tCfg.tMsg)
end

function MsgHandler.packC2SMsg(v_tCfg)
	return packMsg(1,v_tCfg.iMsgType,v_tCfg.iMsgId,v_tCfg.tMsg)
end

function MsgHandler.getCfg(v_sCfgName)
	return CFG[v_sCfgName]
end

return MsgHandler