local HomepageCtrl = class(CtrlBase)

function HomepageCtrl:Ctor()
	self.CMDS["GoBackLogin"] = self.OnCmdGoBackLogin
	self:AddSocketListener(40001,self.OnNetBackLogin)
end

function HomepageCtrl:OnCmdGoBackLogin(v_oSender)
	Network.SendMsg(10001,{account_id = gAccount.uid})
end

function HomepageCtrl:Start() 
	self:ShowUniqueView("HomePage")
end


function HomepageCtrl:OnNetBackLogin(v_tMsg)
	if v_tMsg and v_tMsg.code == 1 then
		local loginCtrl = CtrlMgr.GetOrCreateCtrl("Login")
	    loginCtrl:Start()
	    loginCtrl:Reset()
	end
end



return HomepageCtrl