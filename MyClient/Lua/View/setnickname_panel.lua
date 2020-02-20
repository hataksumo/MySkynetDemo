local SetNickNameView = class(ViewBase)

function SetNickNameView:Ctor()
	-- body
end

function SetNickNameView:_OnInit()
	self.comBehaviour:AddClick(self.goBtnEnsure,function()
		self:OnBtnEnsure()
	end)
	self.CMDS["Warning"] = self.OnCmdWarning
	self.CMDS["HideWarning"] = self.OnCmdHideWarning
	self.CMDS["Reset"] = self.OnCmdReset
end

function SetNickNameView:InitShow()
	self:Reset(self)
end

function SetNickNameView:Warning(v_iWarningId)
	self.goTxtWarning:SetActive(true)
	local wnWd = WordMgr.GetWord(v_iWarningId)
	self.comTxtWarning.text = WordMgr.GetWord(v_iWarningId)
end

function SetNickNameView:OnCmdHideWarning(v_oSender)
	self:HideWarning()
end

function SetNickNameView:HideWarning()
	self.goTxtWarning:SetActive(false)
end

function SetNickNameView:OnCmdWarning(v_oSender,v_iWarningId)
	self:Warning(v_iWarningId)
end

function SetNickNameView:OnCmdReset(v_oSender)
	self:Reset()
end

function SetNickNameView:Reset()
	self:HideWarning(v_oSender)
	self.comTxtWarning.text = ""
	self.comIptNickName.text = ""
end

function SetNickNameView:OnBtnEnsure()
	self:SendCtrlMsg("SelectPlayer","EnsureNickName",self.comIptNickName.text)
end

return SetNickNameView