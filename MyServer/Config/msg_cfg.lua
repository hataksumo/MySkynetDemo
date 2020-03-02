--[[
output from excel Asset.资源.xlsx
--note:
消息的配置
消息的配置
colums:
{ProtoName,协议名} ,{SrvReqHandler,服务端消息逻辑名}
primary key:
#0 [MsgC2S]: MsgType,IntKey
#1 [MsgS2C]: MsgType,IntKey
]]
local _T = LangUtil.Language
if ddt["msg_cfg"] ~= nil then
	return ddt["msg_cfg"]
end
local data = {
	C2S = {
		[10001] = {ProtoName = "ReqBackToLogin",SrvReqHandler = "BackToLogin"},--返回登陆
		[10010] = {ProtoName = "ReqLogin",SrvReqHandler = "Login"},--登陆请求
		[10011] = {ProtoName = "ReqUsrNameValid",SrvReqHandler = "UsrNameValid"},--验证账号
		[10020] = {ProtoName = "ReqRegist",SrvReqHandler = "Regist"},--注册
		[10030] = {ProtoName = "ReqPullPlayerList",SrvReqHandler = "PullPlayerList"},--拉取角色列表
		[10031] = {ProtoName = "ReqPullPlayerInfo",SrvReqHandler = "PullPlayerInfo"},--拉取角色信息
		[10032] = {ProtoName = "ReqNewPlayer",SrvReqHandler = "NewPlayer"},--新建角色
		[10033] = {ProtoName = "ReqChangeNickName",SrvReqHandler = "ChangeNickName"},--更改角色昵称
		[10040] = {ProtoName = "ReqGatherRes",SrvReqHandler = "GatherRes"}--采集
	},
	S2C = {
		[40000] = {ProtoName = "RspERR"},--错误
		[40001] = {ProtoName = "RspBackToLogin"},--返回登陆回复
		[40002] = {ProtoName = "Heartbeat"},--心跳
		[40010] = {ProtoName = "RspUsrNameValid"},--验证账号回复
		[40011] = {ProtoName = "RspLogin"},--登陆请求回复
		[40020] = {ProtoName = "RspRegist"},--注册请求回复
		[40030] = {ProtoName = "RspPullPlayerList"},--拉取角色列表回复
		[40031] = {ProtoName = "RspPullPlayerInfo"},--拉取角色信息回复
		[40032] = {ProtoName = "RspNewPlayer"},--新建角色回复
		[40033] = {ProtoName = "RspChangeNickName"},--设置昵称回复
		[40040] = {ProtoName = "RspGather"},--采集反馈
		[41000] = {ProtoName = "RspResChange"}--资源变化
	}
}
ddt["msg_cfg"] = data
return data