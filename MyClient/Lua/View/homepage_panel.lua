local HomepageView = class(ViewBase)

function HomepageView:Ctor()
	self.CMDS["InitRes"] = self.OnCmdInitRes
	self.CMDS["InitClickRes"] = self.OnCmdInitClickRes
	self.CMDS["TempReactClickRes"] = self.OnCmdTempReactClickRes
	self.CMDS["ResChange"] = self.OnCmdResChange
	self.CMDS["UpdateClickRes"] = self.OnCmdUpdateClickRes
	self.CMDS["UpdateClickResProcess"] = self.OnCmdUpdateClickResProcess
end

function HomepageView:_OnInit()
	--self.goBtnSetting = self:GetObj("BtnSetting")
	--self.goSettingPanel = self:GetObj("SettingPanel")
	--self.goBtnGoBackLogin = self:GetObj("SettingPanel/BtnGoBackLogin")
	--self.goBtnSettingPanelClose = self:GetObj("SettingPanel/BtnClose")
	self.comBehaviour:AddClick(self.goBtnSetting,function()
		self:OnOpenSetting()
	end)
	self.comBehaviour:AddClick(self.goBtnGoBackLogin,function()
		self:SendCtrlMsg("HomePage","GoBackLogin")
	end)
	self.comBehaviour:AddClick(self.goBtnSettingPanelClose,function()
		self:OnSettingPanelClose()
	end)
	self.comBehaviour:AddEvent(self.goBtnFood,EventTriggerType.PointerDown,function()
		self:BeginTouchGather(1)
	end)
	self.comBehaviour:AddEvent(self.goBtnFood,EventTriggerType.PointerUp,function()
		self:EndTouchTouchGather(1)
	end)
	self.comBehaviour:AddEvent(self.goBtnWood,EventTriggerType.PointerDown,function()
		self:BeginTouchGather(2)
	end)
	self.comBehaviour:AddEvent(self.goBtnWood,EventTriggerType.PointerUp,function()
		self:EndTouchTouchGather(2)
	end)
	self.comBehaviour:AddEvent(self.goBtnStone,EventTriggerType.PointerDown,function()
		self:BeginTouchGather(3)
	end)
	self.comBehaviour:AddEvent(self.goBtnStone,EventTriggerType.PointerUp,function()
		self:EndTouchTouchGather(3)
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

function HomepageView:OnCmdInitRes(v_oSender,v_tResCnt)
	self.comTxtRes1Stock.text = tostring(v_tResCnt[101])
	self.comTxtRes2Stock.text = tostring(v_tResCnt[102])
	self.comTxtRes3Stock.text = tostring(v_tResCnt[103])
end

function HomepageView:OnCmdInitClickRes(v_oSender,v_arrClickResInfo)
	self.comImgRes1Process.fillAmount = v_arrClickResInfo[1].stock / v_arrClickResInfo[1].maxStock
	self.comImgRes2Process.fillAmount = v_arrClickResInfo[2].stock / v_arrClickResInfo[2].maxStock
	self.comImgRes3Process.fillAmount = v_arrClickResInfo[3].stock / v_arrClickResInfo[3].maxStock
end


function HomepageView:BeginTouchGather(v_iSlot)
	self:SendCtrlMsg("HomePage","BeginGather",v_iSlot)
end

function HomepageView:EndTouchTouchGather(v_iSlot)
	self:SendCtrlMsg("HomePage","EndGather",v_iSlot)
end

function HomepageView:OnCmdTempReactClickRes(v_oSender,v_iSlot,v_arrAddRes,v_fProcess)
	local resIdToComTxt = {
		[101] = self.comTxtRes1Stock,
		[102] = self.comTxtRes2Stock,
		[103] = self.comTxtRes3Stock
	}
	for _i,data in ipairs(v_arrAddRes) do
		local id = data.id
		if resIdToComTxt[id] then
			resIdToComTxt[id].text = tostring(data.val)
		end
	end
	local arrComImgResProcesses = {
		[1] = self.comImgRes1Process,
		[2] = self.comImgRes2Process,
		[3] = self.comImgRes3Process,
	}
	arrComImgResProcesses[v_iSlot].fillAmount = v_fProcess
end

function HomepageView:OnCmdResChange(v_oSender, v_arrResInfo)
	self.comTxtRes1Stock.text = v_arrResInfo[101].cnt
	self.comTxtRes2Stock.text = v_arrResInfo[102].cnt
	self.comTxtRes3Stock.text = v_arrResInfo[103].cnt
end

function HomepageView:OnCmdUpdateClickRes(v_oSender, v_arrResInfo)
	local arrComImgResProcesses = {
		[1] = self.comImgRes1Process,
		[2] = self.comImgRes2Process,
		[3] = self.comImgRes3Process,
	}
	for _slot=1,3 do
		local theSlotResInfo = v_arrResInfo[_slot]
		arrComImgResProcesses[_slot].fillAmount = theSlotResInfo.stock / theSlotResInfo.maxStock
	end
end

function HomepageView:OnCmdUpdateClickResProcess(v_oSender,v_arrfProcess)
	local arrComImgResProcesses = {
		[1] = self.comImgRes1Process,
		[2] = self.comImgRes2Process,
		[3] = self.comImgRes3Process,
	}
	for _slot=1,3 do
		arrComImgResProcesses[_slot].fillAmount = v_arrfProcess[_slot]
	end
end

return HomepageView