local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 1024

skynet.start(function()
	skynet.error("Server start")
	local watchdog = skynet.newservice("watchdog")
	print("+++++++++++++++++++++++++++++++++")
	local cfgLoader = skynet.newservice("config_loader")
	print("++++++++++++++111++++++++++++++++")
	local sqlServer = skynet.newservice("sql")
	print("+++++++++++++++222++++++++++++++++")
	local loginServer = skynet.newservice("login_service")
	print("===========111========")
	skynet.call(sqlServer,"lua","start",{})
	print("===========222=========")


	skynet.call(watchdog, "lua", "start", {
		address = "192.168.1.4",
		port = 8888,
		maxclient = max_client,
		nodelay = true,
		config_loader = cfgLoader
	})
	print("======================")

	skynet.exit()
end)
