local LoginCtrl = class(CtrlBase)

function LoginCtrl:Ctor(v_cfg)
	self.sIniView = "Login"
	self.sUsrName = nil
	self.CMDS["EnsureUsrName"] = self.OnCmdEnsureUsrName
	self.CMDS["EnsurePswd"] = self.OnCmdEnsurePswd
	self.CMDS["Reset"] = self.OnCmdReset
	self.CMDS["GoToRegist"] = self.OnCmdGoToRegist
	self.CMDS["Regist"] = self.OnCmdRegist
	self.CMDS["CancelUsrName"] = self.OnCmdCancelUsrName
	self.CMDS["GoBackLogin"] = self.OnCmdBackLogin
	self:AddSocketListener(20010,self.OnNetEnsureUsrName)
	self:AddSocketListener(20011,self.OnNetEnsurePswd)
	self:AddSocketListener(20020,self.OnNetRegist)
end

function LoginCtrl:OnCmdEnsureUsrName(v_oSender,v_sUserName)
	self:EnsureUsrName(v_sUserName)
end

function LoginCtrl:OnCmdEnsurePswd(v_oSender,v_sPswd)
	self:EnsurePswd(v_sPswd)
end


function LoginCtrl:EnsureUsrName(v_sUserName)
	if string.IsNullOrEmpty(v_sUserName) then
		ViewMgr.SendMsg("Login","Warning",self,10005)
		return
	end
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
end


function LoginCtrl:EnsurePswd(v_sPswd)
	Network.SendMsg(10010,{usrName = self.sUsrName,passwd = v_sPswd})
end

function LoginCtrl:OnNetEnsurePswd(v_tRsp)
	if v_tRsp.code == 1 then
		local homePageCtrl = CtrlMgr.GetOrCreateCtrl("HomePage")
		homePageCtrl:ShowUnique(true)
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
	Network.SendMsg(10020,{usrName = v_sUserName,passwd = v_sPswd})
end

function LoginCtrl:OnNetRegist(v_tRsp)
	if v_tRsp.code == 1 then
		self.sUsrName = v_tRsp.usrName
		ViewMgr.ShowUnique("HomePage")
	elseif v_tRsp.code == 2 then
		ViewMgr.SendMsg("Regist","Reset",self)
		ViewMgr.SendMsg("Regist","Warning",self,10007)
	elseif v_tRsp.code == 3 then
		ViewMgr.SendMsg("Regist","Reset")
		ViewMgr.SendMsg("Regist","Warning",self,10004)
	elseif v_tRsp.code == 4 then
		ViewMgr.SendMsg("Regist","Reset")
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
	ViewMgr.ShowUnique("Regist")
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