local message = [[
.RspUsrNameValid{
	code 0 : integer	#1 成功  2 用户名不存在
	usrName 1 : string
}
.RspLogin{
	code 0 : integer	#1 成功	2 用户名和密码不匹配
	uid 1 : integer
}
.RspRegist{
	code 0 : integer	#1 成功	2 用户名不合法 3 用户名已经被注册 4 密码过于简单 5昵称不能重复
	usrName 1 : string
	passwd 2 : string
}
.RspPullPlayerInfo{
	code 0 : integer	#1 可拉取 2 需起名
	uid 1 : integer #角色Id
	usr_name 2 : string #昵称
	city_info 3 : binary  #城市信息
	resbag_info 4 : binary #背包信息
	population 5 : binary  #人口信息
	building 6 : binary  #建筑信息
}
.RspSetNickName{
 	code 0 : integer #1 成功, #2 昵称已被注册
}
]]

return message


