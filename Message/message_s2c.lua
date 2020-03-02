local message = [[
.RspBackToLogin
{#40001
	code 0 : integer #返回信息 1成功 2未知错误
}
.Heartbeat
{#40002
	srvTime 0 : integer #服务器时间
	beatTimes 1 : integer #心跳次数
}
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
.ClickResInfoView
{
	awards 0 : *ItemData #单次点击奖励
	maxStock 1 : integer #最大库存
	stock 2 : integer #存量
	recoverTime 3 : integer #回满时间
	lastUpdateTimeStamp 4 : integer #上次更新时间
}
.CityInfoView
{
	days 0 : integer #日子
	clickRes 1 : *ClickResInfoView #点击信息
}
.RspPullPlayerInfo
{#40031
	code 0 : integer #状态码 1已查到 2没查到
	player_id 1 : integer #唯一码
	nick_name 2 : string #昵称
	db_city_info 3 : binary  #城市信息
	db_resbag_info 4 : binary #背包信息
	db_population 5 : binary  #人口信息
	db_building 6 : binary  #建筑信息
	view_city_info 7 : CityInfoView #城市信息的视图
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
.ResChangeItem
{
	id 0 : integer #道具Id
	cnt 1 : integer #道具数量
	changeCnt 2 : integer #变化数量
}
.RspResChange
{#41000
	changeItems 0 : *ResChangeItem #资源改变集合
}
.RspGather
{#40040
	slot 0 : integer #消耗哪个点击项的资源
	clickResInfo 1 : ClickResInfoView #点击项信息
}
]]

return message