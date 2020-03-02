--[[
output from excel Global.全局.xlsx
--note:
全局配置表
colums:
{valueN,数值型值} ,{valueS,字符串型值} ,{valueB,布尔值} ,{valueNA,数值数组型值} ,{valueSA,字符串数组型值}
primary key:
#0 [Global]: Key
]]
local _T = LangUtil.Language
if ddt["global"] ~= nil then
	return ddt["global"]
end
local data = {
	clickInfo_res_iniIds = {101,201,301}--点击资源1
}
ddt["global"] = data
return data