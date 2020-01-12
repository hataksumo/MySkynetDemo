--[[
output from excel Asset.资源.xlsx
--note:
消息的配置
消息的配置
colums:
{ProtoName,协议名}
primary key:
#0 [MsgC2S]: MsgType,IntKey
#1 [MsgS2C]: MsgType,IntKey
]]
local _T = LangUtil.Language
return{
	C2S = {
		[10010] = {ProtoName = "ReqLogin"},--登陆请求
		[10011] = {ProtoName = "ReqUsrNameValid"},--验证账号
		[10020] = {ProtoName = "ReqRegist"}--注册
	},
	S2C = {
		[20000] = {ProtoName = "RspERR"},--错误
		[20010] = {ProtoName = "RspUsrNameValid"},--验证账号回复
		[20011] = {ProtoName = "RspLogin"},--登陆请求回复
		[20020] = {ProtoName = "RspRegist"}--注册请求回复
	}
}