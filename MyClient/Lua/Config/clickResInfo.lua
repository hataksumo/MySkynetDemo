--[[
output from excel ClickRes.点击资源.xlsx
--note:
主城点击资源的配置
colums:
{ClickAward[1].Id,奖励物[1].Id} ,{ClickAward[1].Val,奖励物[1].数量} ,{RecoverTime,回满时间} ,{Storage,点击数存量}
primary key:
#0 [点击资源]: Id
]]
local _T = LangUtil.Language
return{
	[101] = {ClickAward = {[1] = {Id = 101,Val = 10}},RecoverTime = 600,Storage = 600},
	[102] = {ClickAward = {[1] = {Id = 101,Val = 30}},RecoverTime = 600,Storage = 600},
	[201] = {ClickAward = {[1] = {Id = 102,Val = 20}},RecoverTime = 1800,Storage = 600},
	[202] = {ClickAward = {[1] = {Id = 102,Val = 60}},RecoverTime = 1800,Storage = 600},
	[301] = {ClickAward = {[1] = {Id = 103,Val = 30}},RecoverTime = 3600,Storage = 600},
	[302] = {ClickAward = {[1] = {Id = 103,Val = 90}},RecoverTime = 3600,Storage = 600}
}