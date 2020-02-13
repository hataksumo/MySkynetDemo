local message = [[
.ReqLogin {
	usrName 0 : string
	passwd 1 : string
}
.ReqUsrNameValid{
	usrName 0 : string
}
.ReqRegist{
	usrName 0 : string
	passwd 1 : string
}
.ReqPullPlayerInfo{
	uid 0 : integer
}
.ReqSetNickName{
	nickName 0 : string
}

]]

return message