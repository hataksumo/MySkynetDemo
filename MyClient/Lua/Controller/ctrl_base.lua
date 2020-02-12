CtrlBase = class()
function CtrlBase:Ctor(v_cfg)
	self.sLogicName = v_cfg.Key
	self.arrEventListerer = {}
	self.CMDS = {}
	self.CMDS["Start"] = self.OnCmdStart
	self.CMDS["Init"] = self.OnCmdInit
	self.pending = true
	self.arrPendingCmds = {}
	-- self.bAwake = false
end

function CtrlBase:Finalize()
	--清除绑定的消息
	for _i,tListenerCfg in ipairs(arrEventListerer) do
		Event.RemoveListener(tListenerCfg.id,tListenerCfg.handler)
	end
	self:_OnFinalize()
end

function CtrlBase:_OnFinalize()
	-- body
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
		end)
	end
end

function CtrlBase:ShowUniqueView(v_sViewName)
	if ViewMgr.HasView(v_sViewName) then
		ViewMgr.Show(v_sViewName)
	else
		self:BeginPending()
		ViewMgr.GetOrCreateView(v_sViewName,function()
			self:PendingFinish()
			ViewMgr.Show(v_sViewName)
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

function CtrlBase:AddSocketListener(v_iMsgId,v_fnHandler,...)
	table.insert(self.arrEventListerer,{id = v_iMsgId,handler = v_fnHandler})
	Event.AddListener(v_iMsgId,v_fnHandler,self)
end

function CtrlBase:RegistUpdate()
	
end