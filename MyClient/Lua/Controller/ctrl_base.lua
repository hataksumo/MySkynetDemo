CtrlBase = class()
function CtrlBase:Ctor(v_cfg)
	self.sLogicName = v_cfg.Key
	self.arrEventListerer = {}
	self.CMDS = {}
	self.CMDS["Start"] = self.OnCmdStart
	self.CMDS["Init"] = self.OnCmdInit
	self.CMDS["Exit"] = self.OnCmdExit
	self.pending = true
	self.arrPendingCmds = {}
	self.arrCreatedView = {}
	-- self.bAwake = false
end

function CtrlBase:Finalize(v_bDestroyCreatedView)
	--清除绑定的消息
	print("CtrlBase:Finalize")
	for _i,tListenerCfg in ipairs(self.arrEventListerer) do
		Event.RemoveListener(tListenerCfg.id,tListenerCfg.handler)
	end
	if v_bDestroyCreatedView == nil then
		v_bDestroyCreatedView = true
	end
	if v_bDestroyCreatedView then
		self:DestroyCreatedView()
	end

	self:_OnFinalize()
end

function CtrlBase:_OnFinalize()
	-- body
end

function CtrlBase:Exit()
	CtrlMgr.RemoveCtrl(self.sLogicName)
end

function CtrlBase:OnCmdExit(v_oSender)
	self:Exit()
end

function CtrlBase:CMDCallBack(v_cmd,v_oSender,...)
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

function CtrlBase:BeginPending()
	self.pending = true
end

function CtrlBase:PendingFinish()
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

function CtrlBase:PrepareView(v_sViewName,v_fnOther)
	self:BeginPending()
	ViewMgr.GetOrCreateView(v_sViewName,function()
		table.insert(self.arrCreatedView,v_sViewName)
		self:PendingFinish()
	end)
end

function CtrlBase:ShowView(v_sViewName)
	if ViewMgr.HasView(v_sViewName) then
		ViewMgr.Show(v_sViewName)
	else
		self:BeginPending()
		ViewMgr.GetOrCreateView(v_sViewName,function()
			self:PendingFinish()
			ViewMgr.Show(v_sViewName)
			table.insert(self.arrCreatedView,v_sViewName)
		end)
	end
end

function CtrlBase:ShowUniqueView(v_sViewName)
	if ViewMgr.HasView(v_sViewName) then
		ViewMgr.ShowUnique(v_sViewName)
	else
		self:BeginPending()
		ViewMgr.GetOrCreateView(v_sViewName,function()
			self:PendingFinish()
			ViewMgr.ShowUnique(v_sViewName)
			table.insert(self.arrCreatedView,v_sViewName)
		end)
	end
end


function CtrlBase:Init()

end

function CtrlBase:OnCmdInit(v_oSender)
	self:Init(v_oSender)
end

function CtrlBase:OnCmdStart(v_oSender)
	self:Start(v_oSender)
end

function CtrlBase:AddSocketListener(v_iMsgId,v_fnHandler,v_bEndPending)
	if v_bEndPending == nil then
		v_bEndPending = true
	end
	table.insert(self.arrEventListerer,{id = v_iMsgId,handler = v_fnHandler})
	local fnCallBack = v_fnHandler
	if v_bEndPending then
		fnCallBack = function(v_self,...)
			local params = {...}
			local ok,errMsg = pcall(function()
				v_fnHandler(v_self,table.unpack(params))
				Network.EndRequest()
			end)
			if not ok then
				print("An error occured while callback from msgId "..v_iMsgId..", errMsg is \n"..errMsg.."\n"..debug.traceback())
			end
		end
	end
	Event.AddListener(v_iMsgId,fnCallBack,self)
end

function CtrlBase:RegistUpdate(v_key)
	Game.AddUpdateListerner(v_key,self)
end

function CtrlBase:RemoveUpdate(v_key)
	Game.RemoveUpdateListener(v_key,self)
end

function CtrlBase:SendViewMsg(v_sViewLogicName,v_sCmd,...)
	ViewMgr.SendMsg(v_sViewLogicName,v_sCmd,self,...)
end
function CtrlBase:SendCtrlMsg(v_sCtrlLogicName,v_sCmd,...)
	CtrlMgr.SendMsg(v_sCtrlLogicName,v_sCmd,self,...)
end

function CtrlBase:DestroyCreatedView()
	--print("CtrlBase:DestroyCreatedView")
	for _i,val in ipairs(self.arrCreatedView) do
		--print("DestroyView "..val)
		ViewMgr.DestroyView(val)
	end
	self.arrCreatedView = {}
end

function CtrlBase:ToString()
	return self.sLogicName.."Ctrl"
end