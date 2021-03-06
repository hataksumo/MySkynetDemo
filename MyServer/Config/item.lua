--[[
output from excel Item.道具.xlsx
--note:
道具表
colums:
{Type,类型} ,{IniVal,初始数量}
primary key:
#0 [item]: Id
]]
local _T = LangUtil.Language
if ddt["item"] ~= nil then
	return ddt["item"]
end
local data = {
	[1] = {Type = 1,IniVal = 0},--充值币
	[2] = {Type = 1,IniVal = 0},--钻石
	[3] = {Type = 1,IniVal = 100},--金币
	[101] = {Type = 2,IniVal = 1000},--食物
	[102] = {Type = 2,IniVal = 1000},--矿材
	[103] = {Type = 2,IniVal = 1000},--税收
	[10001] = {Type = 3,IniVal = 2},--加速令
	[10002] = {Type = 3,IniVal = 3},--兔脚
	[10003] = {Type = 3,IniVal = 1},--招贤令
	[20001] = {Type = 4,IniVal = 0},--勃朗宁
	[20002] = {Type = 4,IniVal = 0},--龙胆枪
	[20003] = {Type = 4,IniVal = 0},--乌班大炮
	[20004] = {Type = 4,IniVal = 0},--赤兔马
	[20005] = {Type = 4,IniVal = 0},--冲锋号
	[20006] = {Type = 4,IniVal = 0},--令旗
	[20007] = {Type = 4,IniVal = 0},--战神印
	[50001] = {Type = 5,IniVal = 0}--加速令礼包
}
ddt["item"] = data
return data