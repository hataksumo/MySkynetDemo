require "View/view_base"
ViewMgr = {}

local Views = {}

function ViewMgr.GetOrCreateView(v_sLogicName,v_fnCallBack)
	if Views[v_sLogicName] then
		return Views[v_sLogicName]
	end
	local cfg = abAssetCfg[v_sLogicName]
	if not cfg then
		logError(string.format("abAssetCfg[%s] = nil",v_sLogicName))
		return
	end
	local viewCodePath = "View/"..cfg.View
	local viewClass,errMsg = require(viewCodePath)
	if type(viewClass) == "boolean" then
		logError(v_sLogicName.." GetOrCreateView error :\r\n"..(errMsg or "no return"))
	end
	local viewObj = viewClass:new(cfg)
	ViewMgr.CreatePanel(v_sLogicName,function(v_obj)
		viewObj:Init(v_obj)
		if v_fnCallBack then
			v_fnCallBack(viewObj)
		end
	end)
	Views[v_sLogicName] = viewObj
	return Views[v_sLogicName]
end



function ViewMgr.CreatePanel(v_sLogicName,v_fnCallBack)
	v_sLogicName = v_sLogicName or "null"
	local cfg = abAssetCfg[v_sLogicName]
	if not cfg then
		logError("can't find "..v_sLogicName.."in AbAssetCfg")
		return 
	end
	panelMgr:CreateThePanel(v_sLogicName,cfg.Ab,cfg.AssetName,cfg.Name,v_fnCallBack)
end

-- function ViewMgr.SwitchToNewPanel(v_sLogicName,v_fnCallBack)
-- 	v_sLogicName = v_sLogicName or "nil"
-- 	local cfg = abAssetCfg[v_sLogicName]
-- 	if not cfg then
-- 		logError("can't find "..v_sLogicName.."in AbAssetCfg")
-- 		return 
-- 	end
-- 	print(cfg.Ab," ",cfg.Name)
-- 	panelMgr:SwitchToNewPanel(cfg.Ab,cfg.AssetName,cfg.Name,v_fnCallBack)
-- end

function ViewMgr.HasView(v_sLogicName)
	return Views[v_sLogicName] ~= nil
end

function ViewMgr.DestroyView(v_sLogicName)
	local the_view = Views[v_sLogicName]
	if the_view then
		the_view:finalize()
	end
	local name = abAssetCfg[v_sLogicName].Name
	panelMgr:ClosePanel(name)
end

function ViewMgr.HideView(v_sLogicName)
	local the_view = Views[v_sLogicName]
	if the_view then
		panelMgr:Hide(the_view.sName)
	end
end


function ViewMgr.Show(v_sLogicName,v_bInit)
	if v_bInit == nil then
		v_bInit = true
	end
	local the_view = Views[v_sLogicName]
	if not the_view then
		the_view = ViewMgr.GetOrCreateView(v_sLogicName,function()
			panelMgr:Show(the_view.sName)
			the_view:InitShow()
		end)
	else
		panelMgr:Show(the_view.sName)
		if v_bInit then
			the_view:InitShow()
		end
	end
end


function ViewMgr.ShowUnique(v_sLogicName,v_bInit)
	if v_bInit == nil then
		v_bInit = true
	end
	local the_view = Views[v_sLogicName]
	if not the_view then
		the_view = ViewMgr.GetOrCreateView(v_sLogicName,function()
			panelMgr:ShowUnique(the_view.sName)
			the_view:InitShow()
		end)
	else
		panelMgr:ShowUnique(the_view.sName)
		if v_bInit then
			the_view:InitShow()
		end
	end
	
end



function ViewMgr.SendMsg(v_sLogicName,v_sCmd,v_oSender,...)
	local the_view = Views[v_sLogicName]
	if not the_view then
		logError(string.format("can't find the view keyed %s",v_sLogicName))
	end
	--local extArg = {...}
	--logError("ViewMgr.SendMsg "..v_sCmd.." "..extArg[1])
	the_view:CMDCallBack(v_sCmd,v_oSender,...)
end

function ViewMgr.Awake(v_sLogicName,v_obj)
	ViewMgr.SendMsg(v_sLogicName,"Awake",ViewMgr,v_obj)
end

function ViewMgr.Start(v_sLogicName,v_obj)
	ViewMgr.SendMsg(v_sLogicName,"Start",ViewMgr,v_obj)
end

function ViewMgr.OnClick(v_sLogicName,v_obj)
	ViewMgr.SendMsg(v_sLogicName,"OnClick",ViewMgr,v_obj)
end

function ViewMgr.OnClickEvent(v_sLogicName,v_obj)
	ViewMgr.SendMsg(v_sLogicName,"OnClickEvent",ViewMgr,v_obj)
end