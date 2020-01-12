local HomepageCtrl = class(CtrlBase)

function HomepageCtrl:Ctor()
	self.sIniView = "HomePage"
	self.CMDS["GoBackLogin"] = self.OnCmdGoBackLogin
end

function HomepageCtrl:OnCmdGoBackLogin(v_oSender)
	CtrlMgr.SendMsg("Login","Reset",self)
	CtrlMgr.SendMsg("Login","ShowUnique",self)
end

return HomepageCtrl