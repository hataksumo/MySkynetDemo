local message = [[
.RspUsrNameValid{
	code 0 : integer	#1 成功  2 用户名不存在
	usrName 1 : string
}
.RspLogin{
	code 0 : integer	#1 成功	2 用户名和密码不匹配
}
.RspRegist{
	code 0 : integer	#1 成功	2 用户名不合法 3 用户名已经被注册 4 密码过于简单
	usrName 1 : string
}
]]

return message