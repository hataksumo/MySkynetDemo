--[[
output from excel Asset.资源.xlsx
--note:
配置控制器
colums:
{Key,主键} ,{Ctrl,控制器名}
primary key:
#0 [Controller]: Key
]]
local _T = LangUtil.Language
if ddt["ctrl_cfg"] ~= nil then
	return ddt["ctrl_cfg"]
end
local data = {
	Login = {Key = "Login",Ctrl = "login_ctrl"},
	HomePage = {Key = "HomePage",Ctrl = "homepage_ctrl"},
	OnNetwork = {Key = "OnNetwork",Ctrl = "on_network_ctrl"},
	SelectPlayer = {Key = "SelectPlayer",Ctrl = "select_player_ctrl"}
}
ddt["ctrl_cfg"] = data
return data