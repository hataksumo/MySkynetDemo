--[[
output from excel Asset.资源.xlsx
--note:
消息的配置
消息的配置
colums:
{ProtoName,协议名} ,{SrvReqHandler,服务端消息逻辑名} ,{NeedLogin,是否需要登录}
primary key:
#0 [MsgC2S]: MsgType,IntKey
#1 [MsgS2C]: MsgType,IntKey
]]
local _T = LangUtil.Language
return{
	C2S = {
		[10010] = {ProtoName = "ReqLogin",SrvReqHandler = "Login",NeedLogin = false},--登陆请求
		[10011] = {ProtoName = "ReqUsrNameValid",SrvReqHandler = "UsrNameValid",NeedLogin = false},--验证账号
		[10020] = {ProtoName = "ReqRegist",SrvReqHandler = "Regist",NeedLogin = false},--注册
		[10030] = {ProtoName = "ReqPullPlayerInfo",SrvReqHandler = "PullPlayerInfo",NeedLogin = true},--拉取角色信息
		[10040] = {ProtoName = "ReqSetNickName",SrvReqHandler = "SetNickName",NeedLogin = true}--设置昵称
	},
	S2C = {
		[40000] = {ProtoName = "RspERR"},--错误
		[40010] = {ProtoName = "RspUsrNameValid"},--验证账号回复
		[40011] = {ProtoName = "RspLogin"},--登陆请求回复
		[40020] = {ProtoName = "RspRegist"},--注册请求回复
		[40030] = {ProtoName = "RspPullPlayerInfo"},--拉取角色信息回复
		[40040] = {ProtoName = "RspSetNickName"}--设置昵称回复
	}
}