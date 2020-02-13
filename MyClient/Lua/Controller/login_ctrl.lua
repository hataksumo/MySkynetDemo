local LoginCtrl = class(CtrlBase)

function LoginCtrl:Ctor()
	self.sIniView = "Login"
	self.sUsrName = nil
	self.sPasswd = nil
	self.CMDS["EnsureUsrName"] = self.OnCmdEnsureUsrName
	self.CMDS["EnsurePswd"] = self.OnCmdEnsurePswd
	self.CMDS["Reset"] = self.OnCmdReset
	self.CMDS["GoToRegist"] = self.OnCmdGoToRegist
	self.CMDS["Regist"] = self.OnCmdRegist
	self.CMDS["CancelUsrName"] = self.OnCmdCancelUsrName
	self.CMDS["GoBackLogin"] = self.OnCmdBackLogin
	self:AddSocketListener(40010,self.OnNetEnsureUsrName)
	self:AddSocketListener(40011,self.OnNetCheckLogin)
	self:AddSocketListener(40020,self.OnNetRegist)
end

function LoginCtrl:Start()
	self:ShowUniqueView("Login")
end


function LoginCtrl:OnCmdEnsureUsrName(v_oSender,v_sUserName)
	self:EnsureUsrName(v_sUserName)
end

function LoginCtrl:OnCmdEnsurePswd(v_oSender,v_sPswd)
	self:EnsurePswd(v_sPswd)
end


function LoginCtrl:EnsureUsrName(v_sUserName)
	print("LoginCtrl:EnsureUsrName")
	if string.IsNullOrEmpty(v_sUserName) then
		ViewMgr.SendMsg("Login","Warning",self,10005)
		return
	end
	CtrlMgr.SendMsg("OnNetwork","BeginRequest",self)
	Network.SendMsg(10011,{usrName = v_sUserName})
end

function LoginCtrl:OnNetEnsureUsrName(v_tRsp)
	if v_tRsp.code == 1 then--验证通过
		ViewMgr.SendMsg("Login","ChangeMod",self,2)
		ViewMgr.SendMsg("Login","HideWarning",self,2)
		self.sUsrName = v_tRsp.usrName
	elseif v_tRsp.code == 2 then--用户名不存在
		ViewMgr.SendMsg("Login","Warning",self,10001)
	else
		ViewMgr.SendMsg("Login","Warning",self,10000)
	end
	CtrlMgr.SendMsg("OnNetwork","EndRequest",self)
end


function LoginCtrl:EnsurePswd(v_sPswd)
	CtrlMgr.SendMsg("OnNetwork","BeginRequest",self)
	Network.SendMsg(10010,{usrName = self.sUsrName,passwd = v_sPswd})
end


local function _LoginSuccess(v_tRsp)
	gAccount.InitWithLogin(v_tRsp.uid)
	local homePageCtrl = CtrlMgr.GetOrCreateCtrl("HomePage")
	homePageCtrl:Start()
end

function LoginCtrl:OnNetCheckLogin(v_tRsp)
	--print("OnNetCheckLogin")
	CtrlMgr.SendMsg("OnNetwork","EndRequest",self)
	if v_tRsp.code == 1 then
		_LoginSuccess(v_tRsp)
	elseif v_tRsp.code == 2 then
		ViewMgr.SendMsg("Login","Warning",self,10002)
	else
		ViewMgr.SendMsg("Login","Warning",self,10000)
	end
end

function LoginCtrl:OnCmdRegist(v_oSender,v_sUserName,v_sPswd,v_sPswdCfm)
	if not v_sUserName then
		ViewMgr.SendMsg("Regist","Warning",self,10005)
		return
	end
	if not v_sPswd then
		ViewMgr.SendMsg("Regist","Warning",self,10006)
		return
	end
	if v_sPswd ~= v_sPswdCfm then
		ViewMgr.SendMsg("Regist","Warning",self,10003)
		return
	end

	self:Regist(v_sUserName,v_sPswd)
end


function LoginCtrl:Regist(v_sUserName,v_sPswd)
	CtrlMgr.SendMsg("OnNetwork","BeginRequest")
	Network.SendMsg(10020,{usrName = v_sUserName,passwd = v_sPswd})
end

function LoginCtrl:OnNetRegist(v_tRsp)
	CtrlMgr.SendMsg("OnNetwork","EndRequest")
	if v_tRsp.code == 1 then--成功
		self.sUsrName = v_tRsp.usrName
		self.sPasswd = v_tRsp.passwd
		CtrlMgr.SendMsg("OnNetwork","BeginRequest")
		Network.SendMsg(10010,{usrName = self.sUsrName,passwd = self.sPasswd})
		--ViewMgr.ShowUnique("HomePage")
	elseif v_tRsp.code == 2 then--用户名不合法
		ViewMgr.SendMsg("Regist","Reset",self)
		ViewMgr.SendMsg("Regist","Warning",self,10007)
	elseif v_tRsp.code == 3 then--用户名已注册
		ViewMgr.SendMsg("Regist","Reset")
		ViewMgr.SendMsg("Regist","Warning",self,10004)
	elseif v_tRsp.code == 4 then--密码过于简单
		ViewMgr.SendMsg("Regist","ResetPasswd")
		ViewMgr.SendMsg("Regist","Warning",self,10008)
	elseif v_tRsp.code == 5 then
		ViewMgr.SendMsg("Regist","Reset")
		ViewMgr.SendMsg("Regist","Warning",self,10009)
	elseif v_tRsp.code == 6 then
		ViewMgr.SendMsg("Regist","Warning",self,10010)
	end
end



function LoginCtrl:Reset()
	ViewMgr.SendMsg("Login","ChangeMod",self,1)
	ViewMgr.SendMsg("Login","Clear",self)
end

function LoginCtrl:OnCmdReset(v_oSender)
	self:Reset()
end

function LoginCtrl:OnCmdGoToRegist(v_oSender)
	--Network.HelloToSrv("hello server")

	ViewMgr.SendMsg("Login","Clear",self)
	self:ShowUniqueView("Regist")
end

function LoginCtrl:OnCmdCancelUsrName(v_oSender)
	ViewMgr.SendMsg("Login","Clear",self)
	ViewMgr.SendMsg("Login","ChangeMod",self,1)
end



function LoginCtrl:OmCmdGoBackLogin(v_oSender)
	ViewMgr.ShowUnique("Login")
end

function LoginCtrl:OnCmdCancelUsrName(v_oSender)
	self.sUsrName = nil
	self.sPswd = nil
	ViewMgr.SendMsg("Login","Clear",self)
	ViewMgr.SendMsg("Login","ChangeMod",self,1)
end

function LoginCtrl:OnCmdBackLogin(v_oSender)
	ViewMgr.ShowUnique("Login")
end


return LoginCtrl