local RegistView = class(ViewBase)

function RegistView:Ctor()
	self.CMDS["Warning"] = self.OnCmdWarning
	self.CMDS["HideWarning"] = self.OnCmdHideWarning
	self.CMDS["Reset"] = self.OnCmdReset
	self.CMDS["ResetPasswd"] = self.OnCmdResetPasswd
end

function RegistView:_OnInit()
	self.comBehaviour:AddClick(self.goBtnRegistEnsure,function()
		self:OnBtnRegist()
	end)
	self.comBehaviour:AddClick(self.goBtnBack,function()
		self:OnBtnBack()
	end
	)
end

function RegistView:InitShow()
	self:HideWarning()

end

function RegistView:OnBtnRegist()
	self:SendCtrlMsg("Login","Regist",self.comIptUsrName.text,self.comIptPswd.text,self.comIptPswdCfm.text)
end

function RegistView:Warning(v_iWarningId)
	self.goTxtWarning:SetActive(true)
	local wnWd = WordMgr.GetWord(v_iWarningId)
	self.comTxtWarning.text = WordMgr.GetWord(v_iWarningId)
end

function RegistView:OnCmdWarning(v_oSender,v_iWarningId)
	self:Warning(v_iWarningId)
end

function RegistView:HideWarning()
	self.goTxtWarning:SetActive(false)
end

function RegistView:OnCmdHideWarning(v_oSender)
	self:HideWarning()
end

function RegistView:OnBtnBack()
	CtrlMgr.SendMsg("Login","GoBackLogin",self)
end

function RegistView:OnCmdReset(v_oSender)
	self:Clear()
end

function RegistView:OnCmdResetPasswd(v_oSender)
	self.comIptPswd.text = ""
	self.comIptPswdCfm.text = ""
end

function RegistView:Clear()
	self.comIptUsrName.text = ""
	self.comIptPswd.text = ""
	self.comIptPswdCfm.text = ""
end

return RegistView