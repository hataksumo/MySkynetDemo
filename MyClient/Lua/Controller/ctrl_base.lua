CtrlBase = class()
function CtrlBase:Ctor(v_cfg)
	self.sLogicName = v_cfg.Key
	self.arrEventListerer = {}
	self.CMDS = {}
	self.CMDS["Show"] = self.OnCmdShow
	self.CMDS["ShowUnique"] = self.OnCmdShowUnique
	self.CMDS["Init"] = self.OnCmdInit
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
	local the_cmd = self.CMDS[v_cmd]
	if not the_cmd then
		logError(string.format("no cmd %s in view class %sCtrl",v_cmd or "nil",self.sLogicName))
		return
	end
	the_cmd(self,v_oSender,...)
end

function CtrlBase:_InitViewAndShow()
	self:Init()
	self._view = ViewMgr.GetOrCreateView(self.sIniView,function(v_oView)
		ViewMgr.Show(self.sIniView)
	end)
end

function CtrlBase:_InitViewAndShowUnique()
	self:Init()
	self._view = ViewMgr.GetOrCreateView(self.sIniView,function(v_oView)
		ViewMgr.ShowUnique(self.sIniView)
	end)
end


function CtrlBase:InitView()
	self._view = ViewMgr.GetOrCreateView(self.sIniView,function(v_oView)
		v_oView:Hide()
	end)
end

function CtrlBase:Init()

end

function CtrlBase:OnCmdInit(v_oSender)
	self:Init()
end


function CtrlBase:Show(v_bInit)
	if ViewMgr.HasView(self.sIniView) then
		ViewMgr.Show(self.sIniView,v_bInit)
	else
		self:_InitViewAndShow()
	end
end

function CtrlBase:ShowUnique(v_bInit)
	if ViewMgr.HasView(self.sIniView) then
		ViewMgr.ShowUnique(self.sIniView,v_bInit)
	else
		self:_InitViewAndShowUnique()
	end
end

function CtrlBase:OnCmdShow(v_sender,v_bInit)
	self:Show(v_bInit)
end

function CtrlBase:OnCmdShowUnique(v_sender,v_bInit)
	self:ShowUnique(v_bInit)
end

function CtrlBase:AddSocketListener(v_iMsgId,v_fnHandler,...)
	table.insert(self.arrEventListerer,{id = v_iMsgId,handler = v_fnHandler})
	Event.AddListener(v_iMsgId,v_fnHandler,self)
end