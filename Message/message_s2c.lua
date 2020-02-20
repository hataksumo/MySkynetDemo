local message = [[
.RspUsrNameValid
{#40010
	code 0 : integer	#1 成功  2 用户名不存在
	usrName 1 : string
}
.RspLogin
{#40011
	code 0 : integer	#1 成功	2 用户名和密码不匹配
	uid 1 : integer
}
.RspRegist
{#40020
	code 0 : integer	#1 成功	2 用户名不合法 3 用户名已经被注册 4 密码过于简单 5昵称不能重复
	usrName 1 : string
	passwd 2 : string
}
.RspPullPlayerList
{#40030
	player_idlist 0 : *integer #玩家uid列表
}
.RspPullPlayerInfo
{#40031
	code 0 : integer #状态码 1已查到 2没查到
	player_id 1 : integer #唯一码
	nick_name 2 : string #昵称
	city_info 3 : binary  #城市信息
	resbag_info 4 : binary #背包信息
	population 5 : binary  #人口信息
	building 6 : binary  #建筑信息
}
.RspNewPlayer
{#40032
	code 0 : integer #返回信息 1成功 2昵称重复 3服务器角色创建上限 4账号角色创建上限
	uid 1 : integer #玩家uid
}
.RspChangeNickName
{#40033
	code 0 : integer #返回信息 1成功 2昵称重复
}
.RspBackToLogin
{#40001
	code 0 : integer #返回信息 1成功 2未知错误
}

]]

return message