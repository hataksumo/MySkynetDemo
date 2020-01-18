local sproto = require "sprotoparser"
local skynet = require "skynet"
local cfg_msg = require "Config/msg_cfg"
local sharetable = require "skynet.sharetable"


require "Common/define"

local loader = {}
local CMD = {}

skynet.start(function()
	local v_tConf = {}
	v_tConf.c2s = "./../Message/message_c2s.lua"
	v_tConf.s2c = "./../Message/message_s2c.lua"
	local strC2S = dofile(v_tConf.c2s)
	local strS2C = dofile(v_tConf.s2c)
	local strPb = strC2S .. strS2C
	local binPb = sproto.parse(strPb)
	local pb = {}
	pb.sbin = binPb
	sharetable.loadtable("pb",pb)
	sharetable.loadtable("cfg_msg",require "Config/msg_cfg")
end
)
