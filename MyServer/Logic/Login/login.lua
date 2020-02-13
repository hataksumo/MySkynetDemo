local function IsAlphabet(v_cha)
	local the_char = v_cha
	if not(the_char >= string.byte('a') and the_char <= string.byte('z') 
		or the_char >= string.byte('A') and the_char <= string.byte('Z') 
		or the_char >= string.byte('0') and the_char <= string.byte('9') 
		or the_char == string.byte('_') or the_char == string.byte('-') 
		)then
			return false
	end
	 return true
end

local function IsValidUsrName(v_str)
	local len = #v_str
	if len < 7 then
		return false
	end
	for i=1,len do
		local the_char = string.byte(v_str,i)
		if not IsAlphabet(the_char) then
			return false
		end
	end
	return true
end

local function IsValidPasswd(v_str)
	local len = #v_str
	if len < 7 then
		return false
	end
	local hasNumber = false
	local hasAlphabet = false
	for i=1,len do
		local the_char = string.byte(v_str,i)
		if the_char >= string.byte('0') and the_char <= string.byte('9') then
			hasNumber = true
		end
		if the_char >= string.byte('a') and the_char <= string.byte('z')
		or the_char >= string.byte('A') and the_char <= string.byte('Z') then
			hasAlphabet = true
		end

		if not IsAlphabet(the_char) then
			return false
		end
	end
	return hasNumber and hasAlphabet
end

local function LoginSuccess(v_tAccount)
	account = Account:new()
	account.uid = v_tAccount.uid
	account.submission_date = v_tAccount.submission_date
	sendMsg(40011,{code = 1,uid = account.uid})
end


function REQUEST.Login(v_tMsg)
	--print("usrName = "..v_tMsg.usrName.." passwd = "..v_tMsg.passwd)
	local rst,account = skynet.call(".login","lua","Login",v_tMsg.usrName,v_tMsg.passwd)
	if rst then
		LoginSuccess(account)
	else
		sendMsg(40011,{code = 2,uid = -1})
	end

end

function REQUEST.UsrNameValid(v_tMsg)
	print("query user name "..v_tMsg.usrName)
	local rst = skynet.call(".login","lua","HasUser",v_tMsg.usrName)
	if rst then
		sendMsg(40010,{code = 1,usrName = v_tMsg.usrName})
	else
		sendMsg(40010,{code = 2,usrName = "guest"})
	end
end

function REQUEST.Regist(v_tMsg)
	if string.IsNullOrEmpty(v_tMsg.usrName) then
		sendMsg(40020,{code = 2,usrName = v_tMsg.usrName})
		return
	end

	if not IsValidUsrName(v_tMsg.usrName) then
		sendMsg(40020,{code = 2,usrName = v_tMsg.usrName})
		return
	end
	if string.IsNullOrEmpty(v_tMsg.passwd) then
		sendMsg(40020,{code = 4,usrName = v_tMsg.usrName})
		return
	end

	if not IsValidPasswd(v_tMsg.passwd) then
		sendMsg(40020,{code = 4,usrName = v_tMsg.usrName})
		return
	end

	local rst = skynet.call(".login","lua","Regist",v_tMsg.usrName,v_tMsg.passwd)

	if rst then
		sendMsg(40020,{code = rst.code,usrName = v_tMsg.usrName,passwd = v_tMsg.passwd})
		print(v_tMsg.usrName.." regist succesed")
	end
end