local message = [[
.ReqLogin 
{#10010
	usrName 0 : string
	passwd 1 : string
}
.ReqUsrNameValid
{#10011
	usrName 0 : string
}
.ReqRegist
{#10020
	usrName 0 : string
	passwd 1 : string
}
.ReqPullPlayerList
{#10030
	account_id 0 : integer
}
.ReqPullPlayerInfo
{#10031
	uid 0 : integer
}
.ReqNewPlayer
{#10032
	nickName 0 : string
}
.ReqChangeNickName
{#10033
	nickName 0 : string
}
.ReqBackToLogin
{#10001
	account_id 0 : string
}

]]

return message