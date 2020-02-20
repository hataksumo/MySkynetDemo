--[[
output from excel Asset.资源.xlsx
--note:
配置在代码中出现的文字
colums:
{Cn,中文} ,{En,英文}
primary key:
#0 [Words]: Id
]]
local _T = LangUtil.Language
if ddt["words_cfg"] ~= nil then
	return ddt["words_cfg"]
end
local data = {
	[10000] = {Cn = "未知文字"},
	[10001] = {Cn = "输入的账号不存在"},
	[10002] = {Cn = "账号和密码不匹配"},
	[10003] = {Cn = "两次输入的密码不相同"},
	[10004] = {Cn = "账号已被注册"},
	[10005] = {Cn = "账号不能为空"},
	[10006] = {Cn = "密码不能为空"},
	[10007] = {Cn = "账号不合法，必须是由数字或字符组成，长度大于7"},
	[10008] = {Cn = "密码太过简单，必须是由数字和字符组成，长度大于7"},
	[10009] = {Cn = "昵称已被注册"},
	[10010] = {Cn = "服务端未知sql错误"},
	[10011] = {Cn = "服务器角色创建上限"},
	[10012] = {Cn = "账号角色创建上限"},
	[10013] = {Cn = "请求的角色不存在"}
}
ddt["words_cfg"] = data
return data