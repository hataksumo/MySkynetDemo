NetProtoC2SType = {
	Msg			= 100;	--正常消息
	HeartBeat   = 101;	--心跳，长度+大类型+小类型+pb串
	RawText     = 102;  --纯文本
}

NetProtoS2CType = {
	Connect		= 101;	--连接服务器
	Exception   = 102;	--异常掉线
	Disconnect  = 103;	--正常断线   
	Msg			= 104;	--接收消息
	HeartBeat   = 105;	--心跳，长度+大类型+小类型+pb串
	RawText		= 100;  --纯文本
	SrvErr		= 99;   --服务器错误
}
