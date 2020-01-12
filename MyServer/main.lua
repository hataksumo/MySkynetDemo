local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 1024

skynet.start(function()
	skynet.error("Server start")
	local watchdog = skynet.newservice("watchdog")
	local cfgLoader = skynet.newservice("config_loader")
	skynet.call(watchdog, "lua", "start", {
		address = "192.168.1.4",
		port = 8888,
		maxclient = max_client,
		nodelay = true,
		config_loader = cfgLoader
	})
	
	skynet.call(cfgLoader, "lua", "start", {
	 	c2s = "./../Message/message_c2s.lua",
	 	s2c = "./../Message/message_s2c.lua"
	 })


	skynet.exit()
end)
