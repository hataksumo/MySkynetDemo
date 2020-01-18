local skynet = require "skynet"
require "skynet.manager"

local accounts = {}

local CMD = {}

function CMD.HasUser(v_sUsr)
	local account = accounts[v_sUsr]
	if account then
		return true
	end
	local ok,res = skynet.call(".sql","lua","Querycb","HasUsrName",{v_sUsr})
	if res.cnt > 0 then
		return true
	end
	return false
end

function CMD.Login(v_sUsr,v_sPswd)
	local account = accounts[v_sUsr]
	if account and account.passwd then
		if v_sPswd == account.passwd then
			return true,account
		else
			return false
		end
	else
		local ok,rst = skynet.call(".sql","lua","Querycb","CheckLogin",{v_sUsr,v_sPswd})
		if rst.cnt > 0 then
			account = {}
			account.uid = rst.uid
			account.passwd = v_sPswd
			accounts[v_sUsr] = account
			return true,account
		end
		return false
	end
end

function CMD.Regist(v_sUsr,v_sPswd)
	if accounts[v_sUsr] then
		return {code = 3}
	else
		local ok,res = skynet.call(".sql","lua","Querycb","HasUsrName",{v_sUsr})
		if res.cnt > 0 then
			accounts[v_sUsr] = {}
			return {code = 3}
		end
	end
	accounts[v_sUsr] = {}
	accounts[v_sUsr].usr_name = v_sUsr
	accounts[v_sUsr].passwd = v_sPswd

	local ok,rtn = skynet.call(".sql","lua","Querycb","Regist",{v_sUsr,v_sPswd,"now()"})
	if ok then
		return {code = 1}
	else
		return {code = 6,err = rtn}
	end
end


skynet.start( function()
	skynet.dispatch("lua",function(_,_,cmd,...)
		local f = CMD[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		else
			print("login_service cmd "..cmd.." not find")
		end
	end
	)
	skynet.register ".login"
end)
