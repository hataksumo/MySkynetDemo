local HomepageCtrl = class(CtrlBase)

function HomepageCtrl:Ctor()
	self.CMDS["GoBackLogin"] = self.OnCmdGoBackLogin
end

function HomepageCtrl:OnCmdGoBackLogin(v_oSender)
	CtrlMgr.SendMsg("Login","Reset",self)
	CtrlMgr.SendMsg("Login","ShowUnique",self)
end

function HomepageCtrl:Start()
	Network.SendMsg(10030,{uid = gAccount.GetUid()})
	self:ShowUniqueView("HomePage")
end



return HomepageCtrl