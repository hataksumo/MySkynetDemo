--[[
output from excel Item.道具.xlsx
--note:
道具表
colums:
{Type,类型} ,{Name,名称} ,{Icone,图标} ,{Desc,描述}
primary key:
#0 [item]: Id
]]
local _T = LangUtil.Language
if ddt["item"] ~= nil then
	return ddt["item"]
end
local data = {
	[1] = {Type = 1,Name = "如梦别",Desc = "通过充值所获得的道具，美其名曰如梦别"},--充值币
	[2] = {Type = 1,Name = "原石",Desc = "来自于宇宙奇点的一种材料，大爆炸后散落于世界各地，是物质与精神的结合物。"},--钻石
	[3] = {Type = 1,Name = "金币",Desc = "宇宙联邦中央银行发售的一种信用货币，可在宇宙商店中购买各种材料，也用于各国的交易。"},--金币
	[101] = {Type = 2,Name = "食物",Desc = "王国的食物，以供人口的消耗，是支撑王国运作的基础资源"},--食物
	[102] = {Type = 2,Name = "矿材",Desc = "王国的矿材，可加工成各种材料，是支撑王国运作的基础资源"},--矿材
	[103] = {Type = 2,Name = "税收",Desc = "王国的税收，用于王国政府的运作，是支撑王国运作的基础资源"},--税收
	[10001] = {Type = 3,Name = "时空印记",Desc = "用于使时间静止，瞬间完成许多事情"},--加速令
	[10002] = {Type = 3,Name = "兔脚",Desc = "象征着幸运，可以送给其他国家，增加友好度"},--兔脚
	[10003] = {Type = 3,Name = "招贤令",Desc = "进行一次科举，招募一些工作人员"},--招贤令
	[20001] = {Type = 4,Name = "勃朗宁",Desc = "增加将领的火力"},--勃朗宁
	[20002] = {Type = 4,Name = "龙胆枪",Desc = "增加将领的冲击"},--龙胆枪
	[20003] = {Type = 4,Name = "乌班大炮",Desc = "增加将领的围成"},--乌班大炮
	[20004] = {Type = 4,Name = "赤兔马",Desc = "增加将领的速度"},--赤兔马
	[20005] = {Type = 4,Name = "冲锋号",Desc = "增加将领的士气"},--冲锋号
	[20006] = {Type = 4,Name = "令旗",Desc = "增加将领的训练度"},--令旗
	[20007] = {Type = 4,Name = "战神印",Desc = "增加将领的幸运"},--战神印
	[50001] = {Type = 5,Name = "加速令礼包",Desc = "打开后获得10个加速令"}--加速令礼包
}
ddt["item"] = data
return data