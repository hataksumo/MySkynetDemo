ViewBase = class()
function ViewBase:Ctor(v_cfg)
	self.sName = v_cfg.Name
	self.sLogicName = v_cfg.Key
	self.root = nil
	self.transform = nil
	self.CMDS = {}
	self.CMDS["Close"] = ViewBase.Close
	self.CMDS["Awake"] = ViewBase.OnCmdAwake
	self.CMDS["Start"] = ViewBase.OnCmdStart
	self.arrPendingCmds = {}
	self.pending = false
	--self.CMDS["Click"] = ViewBase.OnCmdClick
	--self.CMDS["ClickEvent"] = ViewBase.OnCmdClickEvent
end

function ViewBase:Init(v_obj)
	self.root = v_obj
	self.transform = self.root.transform
	if self.transform == nil then
		logError("ViewBase:Init self.transform = nil")
	end
	self.comBehaviour = self.root:GetComponent('LuaBehaviour')
	self:InitWithWidget()
	self:_OnInit()
end

function ViewBase:InitWithWidget()
	local widget_cfgs = abAssetCfg[self.sLogicName]
	local widgets = widget_cfgs.Widgets
	for widget,widget_cfg in pairs(widgets) do
		if widget_cfg.Type == "GameObject" then
			self[widget] = self:GetObj(widget_cfg.Path)
		elseif widget_cfg.Type == "InputField" then
			self[widget] = self:GetInput(widget_cfg.Path)
		elseif widget_cfg.Type == "Text" then
			self[widget] = self:GetText(widget_cfg.Path)
		elseif widget_cfg.Type == "Image" then
			self[widget] = self:GetImage(widget_cfg.Path)
		else
			logError(string.format("widget's Type is %s has not implemented",widget_cfg.Type))
		end
	end
end

function ViewBase:BeginPending()
	self.pending = true
end

function ViewBase:PendingFinish()
	self.pending = false
	for _i,cmdObj in ipairs(self.arrPendingCmds) do
		local cmd = self.CMDS[cmdObj.cmd]
		if cmd then
			--print("PendingFinish cmd ".._i)
			cmd(self,cmdObj.sender,table.unpack(cmdObj.args))
		else
			logError(string.format("no cmd %s in view class %sCtrl",cmdObj.cmd or "nil",self.sLogicName))
		end
	end
	self.arrPendingCmds = {}
end





function ViewBase:InitShow()

end

function ViewBase:Finalize()
	
end

function ViewBase:Awake(v_object)
	
end

function ViewBase:Star(v_object)
	-- body
end

function ViewBase:OnClick(v_object)
	-- body
end

function ViewBase:OnClickEvent(v_object)
	-- body
end

function ViewBase:OnCmdAwake(v_oSender,v_object)
	self:Awake(v_object)
end

function ViewBase:OnCmdStart(v_oSender,v_object)
	self:Star(v_object)
end

function ViewBase:OnCmdClick(v_oSender,v_object)
	self:OnClick(v_object)
end

function ViewBase:OnCmdEvent(v_oSender,v_object)
	self:OnClickEvent(v_object)
end

function ViewBase:CMDCallBack(v_cmd,v_oSender,...)
	if self.pending then
		--print("insert cmd "..v_cmd)
		local pendCmd = {}
		pendCmd.cmd = v_cmd
		pendCmd.sender = v_oSender
		pendCmd.args = {...}
		table.insert(self.arrPendingCmds,pendCmd)
		return
	end
	--print("excute cmd "..v_cmd)
	local the_cmd = self.CMDS[v_cmd]
	if not the_cmd then
		logError(string.format("no cmd %s in view class %sCtrl",v_cmd or "nil",self.sLogicName))
		return
	end
	the_cmd(self,v_oSender,...)
end

function ViewBase:Close(v_oSender)
	ViewMgr.DestroyView(self.sLogicName)
end

function ViewBase:Hide(v_oSender)
	ViewMgr.Hide(self.sLogicName)
end

function ViewBase:GetObj(v_sPath)
	local obj = self.transform:Find(v_sPath)
	if not obj then
		ZFDebug.Error("can't find the obj "..v_sPath)
		return
	end
	return obj.gameObject
end

function ViewBase:GetComponent(v_sPath,v_sComName)
	local obj = self:GetObj(v_sPath)
	if not obj then 
		return
	end
	local comText = obj:GetComponent(v_sComName)
	if not comText then
		ZFDebug.Error("can't find the component "..v_sComName.." in path "..v_sPath)
	end
	return comText
end

function ViewBase:GetText(v_sPath)
	return self:GetComponent(v_sPath,typeof(UnityEngine.UI.Text))
end

function ViewBase:GetInput(v_sPath)
	return self:GetComponent(v_sPath,typeof(UnityEngine.UI.InputField))
end

function ViewBase:GetImage(v_sPath)
	return self:GetComponent(v_sPath,typeof(UnityEngine.UI.Image))
end

function ViewBase:SendViewMsg(v_sViewLogicName,v_sCmd,...)
	assert(type(v_sViewLogicName)=="string" and type(v_sCmd)=="string","ViewBase:SendViewMsg param type wrong "..debug.traceback())
	ViewMgr.SendMsg(v_sViewLogicName,v_sCmd,self,...)
end
function ViewBase:SendCtrlMsg(v_sCtrlLogicName,v_sCmd,...)
	assert(type(v_sCtrlLogicName)=="string" and type(v_sCmd)=="string","ViewBase:SendCtrlMsg param type wrong "..debug.traceback())
	CtrlMgr.SendMsg(v_sCtrlLogicName,v_sCmd,self,...)
end

function ViewBase:ToString()
	return self.sLogicName.."Panel"
end