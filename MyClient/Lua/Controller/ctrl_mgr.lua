require "Common/define"
require "Common/functions"
require "Controller/ctrl_base"
--require "Controller/HelloSkynetCtrl"
--require "Controller/NotifyCtrl"
--require "Controller/ArmyEquiptProductCtrl"

CtrlMgr = {};
local this = CtrlMgr;
local ctrlList = {};	--控制器列表--

function CtrlMgr.Init()
	return this
end

function CtrlMgr.GetOrCreateCtrl(v_strLogicName)
	if ctrlList[v_strLogicName] then
		return ctrlList[v_strLogicName]
	end
	local cfg = ctrlCfg[v_strLogicName]
	if not cfg then
		logError(string.format("ctrlCfg[%s] = nil",v_strLogicName))
	end
	local ctrlCodePath = "Controller/"..cfg.Ctrl
	local ctrlClass,errMsg = require(ctrlCodePath)
	if type(ctrlClass) == "boolean" then
		logError("class is wrong ")
	end
	local ctrlObj = ctrlClass:new(cfg)
	ctrlList[v_strLogicName] = ctrlObj
	if ctrlObj.sIniView == nil then
		logError(string.format("%sCtrl don't has sIniView",ctrlObj.sIniView))
	end
	return ctrlList[v_strLogicName]
end

--获取控制器--
function CtrlMgr.GetCtrl(v_strLogicName)
	return ctrlList[v_strLogicName];
end

--移除控制器--
function CtrlMgr.RemoveCtrl(v_strLogicName)
	if ctrlList[v_strLogicName] then
		ctrlList[v_strLogicName]:finalize()
	end
	ctrlList[v_strLogicName] = nil;
end

--发送消息
function CtrlMgr.SendMsg(v_sLogicName,v_sCmd,v_oSender,...)
	local the_ctrl = ctrlList[v_sLogicName]
	if not the_ctrl then
		logError(string.format("can't find the view keyed %s",v_sLogicName))
		return
	end
	the_ctrl:CMDCallBack(v_sCmd,v_oSender,...)
end

