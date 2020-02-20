local HomepageView = class(ViewBase)

function HomepageView:Ctor()
	-- body
end

function HomepageView:_OnInit()
	self.goBtnSetting = self:GetObj("BtnSetting")
	self.goSettingPanel = self:GetObj("SettingPanel")
	self.goBtnGoBackLogin = self:GetObj("SettingPanel/BtnGoBackLogin")
	self.goBtnSettingPanelClose = self:GetObj("SettingPanel/BtnClose")
	self.comBehaviour:AddClick(self.goBtnSetting,function()
		self:OnOpenSetting()
	end)
	self.comBehaviour:AddClick(self.goBtnGoBackLogin,function()
		self:SendCtrlMsg("HomePage","GoBackLogin")
	end)
	self.comBehaviour:AddClick(self.goBtnSettingPanelClose,function()
		self:OnSettingPanelClose()
	end)
end

function HomepageView:InitShow()
	self.goSettingPanel:SetActive(false)
end

function HomepageView:OnSettingPanelClose()
	self.goSettingPanel:SetActive(false)
end

function HomepageView:OnOpenSetting()
	self.goSettingPanel:SetActive(true)
end

return HomepageView