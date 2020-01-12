local message = [[
.ReqLogin {
	usrName 0 : string
	passwd 1 : string
}
.ReqUsrNameValid{
	isValid 0 : boolean
	usrName 1 : string
}
.RspUsrNameValid{
	code 0 : integer	#1 成功  2 用户名不存在
	usrName 1 : string
}
.RspLogin{
	code 0 : integer	#1 成功	2 用户名和密码不匹配
}
]]

return message