local SqlStatement = require "DB/sql_statement"

g_prepareSqls = {}

g_prepareSqls["HasUsrName"] = SqlStatement:new("HasUsrName")
g_prepareSqls["HasUsrName"]:InitWithSelectCount("user",{"usr_name"})

g_prepareSqls["HasNickName"] = SqlStatement:new("HasNickName")
g_prepareSqls["HasNickName"]:InitWithSelectCount("user",{"nick_name"})

g_prepareSqls["CheckLogin"] = SqlStatement:new("CheckLogin")
g_prepareSqls["CheckLogin"]:InitWithSelect("user",{"uid","submission_date"},{"usr_name","passwd"},true)

g_prepareSqls["Regist"] = SqlStatement:new("Regist")
g_prepareSqls["Regist"]:InitWithInsert("user",{"usr_name","passwd","nick_name","submission_date"})
g_prepareSqls["Regist"]:AddCmdParam("submission_date")


g_prepareSqls["GetPlayerList"] = SqlStatement:new("GetPlayerList",false)
g_prepareSqls["GetPlayerList"]:InitWithSelect("player_city",{"uid"},{"account_id"})

g_prepareSqls["GetPlayerInfo"] = SqlStatement:new("GetPlayerInfo")
g_prepareSqls["GetPlayerInfo"]:InitWithSelect("player_city",{"nick_name","city_info","resbag_info"},{"uid"})

g_prepareSqls["NewPlayer"] = SqlStatement:new("NewPlayer")
g_prepareSqls["NewPlayer"]:InitWithInsert("player_city",{"account_id","nick_name","city_info","resbag_info"})

g_prepareSqls["GetAccountPlayerCnt"] = SqlStatement:new("GetAccountPlayerCnt")
g_prepareSqls["GetAccountPlayerCnt"]:InitWithSelectCount("player_city",{"account_id"})

g_prepareSqls["HasPlayerNickName"] = SqlStatement:new("HasPlayerNickName")
g_prepareSqls["HasPlayerNickName"]:InitWithSelectCount("player_city",{"nick_name"})

g_prepareSqls["SavePlayer"] = SqlStatement:new("SavePlayer")
g_prepareSqls["SavePlayer"]:InitWithUpdate("player_city",{"city_info","resbag_info"},{"uid"})