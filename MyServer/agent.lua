skynet = require "skynet"
local socket = require "skynet.socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local netpack = require "skynet.netpack"
local sharetable = require "skynet.sharetable"

local WATCHDOG
local CFG_LOADER = nil
local host
local CMD = {}
REQUEST = {}
require "Logic/Login/login"
ProtoSchema = nil
local MsgHandler = require "MsgHandler"
account = nil


local client_fd

function sendMsg(v_iMsgId,v_tMsg)
	local sPackMsg = MsgHandler.packS2CMsg({iMsgType = NetProtoS2CType.Msg,iMsgId = v_iMsgId,tMsg = v_tMsg})
	if sPackMsg == false then
		print("encode failed")
		return
	end
	socket.write(client_fd,sPackMsg)
end


local HeartBeatIdx = 1
local function send_heartbeat(pack)
	local package = string.pack("<HHHs2", #pack+6,NetProtoS2CType.HeartBeat,HeartBeatIdx,pack)
	socket.write(client_fd, package)
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
		local fnHandler = REQUEST[msg.handler]
		if fnHandler then
			local ok,errMsg = pcall(function()
				return fnHandler(msg.tMsg)
			end)
			if not ok then
				print("an error occured while calling handler "..msg.handler..". err msg is \n"..errMsg)
			end	
		else
			print("don't has REQUEST "..msg.handler)
			return
		end
		--skynet.trace()

	end
}

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
		while true do
			send_heartbeat("heartbeat")
			skynet.sleep(500)
		end
	end)

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
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
