skynet = require "skynet"
local socket = require "skynet.socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local netpack = require "skynet.netpack"
sharetable = require "skynet.sharetable"
require "Module/Account/account"
require "Module/Player/player"



local WATCHDOG
local CFG_LOADER = nil
local host
local CMD = {}
REQUEST = {}
ACCOUNT_REQUEST = {}
PLAYER_REQUEST = {}
require "Logic/Login/login"
require "Logic/Login/get_player"
require "Logic/HomePage/ResClick"

ProtoSchema = nil
local MsgHandler = require "MsgHandler"
g_account = nil
g_player = nil


local client_fd

function sendMsg(v_iMsgId,v_tMsg)
	local sPackMsg = MsgHandler.packS2CMsg({iMsgType = NetProtoS2CType.Msg,iMsgId = v_iMsgId,tMsg = v_tMsg})
	if sPackMsg == false then
		print("encode failed")
		return
	end
	socket.write(client_fd,sPackMsg)
end





skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		--print("agent unpack")
		local strMsg = skynet.tostring(msg,sz)
		--return strMsg
		local iMsgType,iMsgId,sMsg = string.unpack("<HHs2",strMsg)
		--print(string.safeFormat("iMsgType = {1}, iMsgId = {2}, sMsg = {3}",iMsgType,iMsgId,string.printByte(sMsg)))
		return iMsgType,iMsgId,sMsg
	end,
	dispatch = function (fd, _, iMsgType,iMsgId,sMsg)
	--dispatch = function (fd, _, v_msg)
		assert(fd == client_fd)	-- You can use fd to reply message
		skynet.ignoreret()	-- session is fd, don't call skynet.ret
		--print(string.safeFormat("iMsgType = {1}, iMsgId = {2}, sMsg = {3}",iMsgType,iMsgId,string.printByte(sMsg)))
		--print("agent dispatch")
		--local iMsgType,iMsgId,sMsg = string.unpack("<HHs2",v_msg)
		local msg = MsgHandler.unpackC2SMsg({iMsgType = iMsgType,iMsgId = iMsgId,sMsg = sMsg})
		if string.IsNullOrEmpty(msg) or msg == "ERROR" then
			print("error msg = "..(msg or "nil"))
			skynet.trace()
			return
		end
		--print("msg = "..print_table(msg))
		if not msg.handler then
			print(string.format("iMsgId = %d don't has handler",iMsgId))
			print( "msg = "..print_table(msg))
			return
		end

		if g_player then
			local fnHandler = PLAYER_REQUEST[msg.handler]
			if not fnHandler then
				print(string.format("PLAYER_REQUEST[%s] = nil",msg.handler))
				return
			else
				fnHandler(msg.tMsg)
				if g_player then
					g_player:SynchronizeItemInfo()
				end
				return
			end
			
		end

		if g_account then
			local fnHandler = ACCOUNT_REQUEST[msg.handler]
			if not fnHandler then
				print(string.format("ACCOUNT_REQUEST[%s] = nil",msg.handler))
				return
			else
				fnHandler(msg.tMsg)
				return
			end
			
		end

		local fnHandler = REQUEST[msg.handler]
		if not fnHandler then
			print(string.format("REQUEST[%s] = nil",msg.handler))
			return
		else
			fnHandler(msg.tMsg)
			return
		end
		
		--skynet.trace()
	end
}

function LogOut()
	if g_player then
		g_player:Save()
	end
end

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- slot 1,2 set at main.lua
	--CFG_LOADER = conf.cfg_loader
	--CFG_LOADER = conf.config_loader
	local pbBin = sharetable.query("pb")
	ProtoSchema = sproto.new(pbBin.sbin)

	skynet.fork(function()
		local heartBeatIdx = 1
		while true do
			sendMsg(40002,{srvTime = os.time(),beatTimes = heartBeatIdx})
			heartBeatIdx = heartBeatIdx + 1
			skynet.sleep(500)
		end
	end)

	-- sharetable.query("cfg_msg")
	-- sharetable.query("cfg_item")
	-- sharetable.query("cfg_global")
	-- sharetable.query("cfg_clickResInfo")


	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	LogOut()
	print("===========agent disconnect==========")
	skynet.exit()
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		--skynet.trace()
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
