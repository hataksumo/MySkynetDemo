local sproto = require "sprotoparser"
local skynet = require "skynet"
local cfg_msg = require "Config/msg_cfg"
local sharetable = require "skynet.sharetable"


require "Common/define"

local loader = {}
local CMD = {}
CFG = {}


skynet.start(function()
	local strC2S = dofile(v_tConf.c2s)
	local strS2C = dofile(v_tConf.s2c)
	local strPb = strC2S .. strS2C
	local binPb = sproto.parse(strPb)
	local pb = {}
	pb.sbin = binPb
	--print(string.printByte(binPb))
	--print(strPb)
	sharetable.loadtable("pb",pb)
	sharetable.loadtable("cfg_msg",require "Config/msg_cfg")
	skynet.exit()
end
)
