local LoginView = class(ViewBase)
function LoginView:Ctor()
	self.mod = 1--1表示输入账号，2表示输入密码，3表示注册
	self.CMDS["ChangeMod"] = function(v_self,v_oSender,v_mod)
		self:ChangeMod(v_mod)
	end
	self.CMDS["Warning"] = function(v_self,v_oSender,v_iWarningId)
		self:Warning(v_iWarningId)
	end
	self.CMDS["HideWarning"] = function(v_self,v_oSender)
		self:HideWarning()
	end
	self.CMDS["Clear"] = function(v_self,v_oSender)
		self:Clear()
	end
end

function LoginView:_OnInit()
	--登陆面板的按钮
	self.comBehaviour:AddClick(self.goBtnLoginEnsure,function()
		self:OnBtnEnsureClick()
	end)
	self.comBehaviour:AddClick(self.goBtnRegist,function()
		self:OnBtnRegist()
	end)
	self.comBehaviour:AddClick(self.goBtnBack,function()
		self:OnBtnBack()
	end)
	self.goTxtWarning:SetActive(false)
	self:ChangeMod(1)
end

function LoginView:OnBtnEnsureClick()
	if self.mod == 1 then
		self:SendCtrlMsg("Login","EnsureUsrName",self.comIptUserName.text)
	elseif self.mod == 2 then
		self:SendCtrlMsg("Login","EnsurePswd",self.comIptPasswd.text)
	end
end

function LoginView:OnBtnRegist()
	self:SendCtrlMsg("Login","GoToRegist")
end

function LoginView:OnBtnBack()
	self:SendCtrlMsg("Login","CancelUsrName")
end

function LoginView:ChangeMod(v_mod)
	self.mod = v_mod
	self:HideWarning()
	if self.mod == 1 then
		self.goUsrName:SetActive(true)
		self.goPswd:SetActive(false)
		self.goBtnBack:SetActive(false)
	elseif self.mod == 2 then
		self.goUsrName:SetActive(false)
		self.goPswd:SetActive(true)
		self.goBtnBack:SetActive(true)
	end
end

function LoginView:Warning(v_iWarningId)
	self.goTxtWarning:SetActive(true)
	self.comTxtWarning.text = WordMgr.GetWord(v_iWarningId)
end

function LoginView:HideWarning()
	self.goTxtWarning:SetActive(false)
end

function LoginView:Clear()
	self.comIptUserName.text = ""
	self.comIptPasswd.text = ""
	self.goTxtWarning:SetActive(false)
end


return LoginView