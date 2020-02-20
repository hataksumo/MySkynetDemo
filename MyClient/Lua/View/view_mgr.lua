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
		logError(v_sLogicName.." view "..viewCodePath.." GetOrCreateView error :\r\n"..(errMsg or "no return"))
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

local function _GetCfg(v_sLogicName)
	v_sLogicName = v_sLogicName or "null"
	local cfg = abAssetCfg[v_sLogicName]
	if not cfg then
		logError("can't find "..v_sLogicName.." in AbAssetCfg")
		return nil
	end
	return cfg
end


function ViewMgr.CreatePanel(v_sLogicName,v_fnCallBack)
	local tCfg = _GetCfg(v_sLogicName)
	panelMgr:CreateThePanel(tCfg.Layer,v_sLogicName,tCfg.Ab,tCfg.AssetName,tCfg.Name,v_fnCallBack)
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
		the_view:Finalize()
	end
	local name = abAssetCfg[v_sLogicName].Name
	local layer = abAssetCfg[v_sLogicName].Layer
	if panelMgr:HasePanel(layer,name) then
		print("panelMgr:ClosePanel "..name)
		panelMgr:ClosePanel(layer,name)
	end
	Views[v_sLogicName] = nil
end

function ViewMgr.HideView(v_sLogicName)
	local tCfg = _GetCfg(v_sLogicName)
	local the_view = Views[v_sLogicName]
	if the_view then
		panelMgr:Hide(tCfg.Layer,the_view.sName)
	end
end


function ViewMgr.Show(v_sLogicName,v_bInit)
	if v_bInit == nil then
		v_bInit = true
	end
	local tCfg = _GetCfg(v_sLogicName)
	local the_view = Views[v_sLogicName] 
	if not the_view then
		print("can't find the view "..v_sLogicName)
		return
	end
	panelMgr:Show(tCfg.Layer,tCfg.Name)
	if v_bInit then
		the_view:InitShow()
	end
end


function ViewMgr.ShowUnique(v_sLogicName,v_bInit)
	if v_bInit == nil then
		v_bInit = true
	end
	local tCfg = _GetCfg(v_sLogicName)
	local the_view = Views[v_sLogicName]
	if not the_view then
		print("can't find the view "..v_sLogicName)
		return
	end
	panelMgr:ShowUnique(tCfg.Layer,tCfg.Name)
	if v_bInit then
		the_view:InitShow()
	end
end

function ViewMgr.HideAll()
	panelMgr:ShowUnique(1,"");
end



function ViewMgr.SendMsg(v_sLogicName,v_sCmd,v_oSender,...)
	local the_view = Views[v_sLogicName]
	if not the_view then
		logError(string.format("can't find the view keyed %s",v_sLogicName))
		return
	end
	local params = {...}
	local ok,errMsg = pcall(function()
		the_view:CMDCallBack(v_sCmd,v_oSender,table.unpack(params))
	end)
	if not ok then
		print("An error occured while calling ViewMgr.SendMsg, errMsg is \n"..errMsg.."\n"..debug.traceback())
		return
	end
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