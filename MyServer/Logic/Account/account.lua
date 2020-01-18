local skynet = require "skynet"

local Account = class()

function Account:Ctor()
	self.bIsLogin = nil
	self.iUid = nil
	self.sNickName = nil
	self.sRegistTimeStamp = nil
end

function Account.Login(v_tCfg)
	self.bIsLogin = true
	self.iUid = v_tCfg.uid
	self.sNickName = v_tCfg.nick_name
	self.sRegistTimeStamp = v_tCfg.usr_name
end



return Account