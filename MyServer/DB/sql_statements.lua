local SqlStatement = require "DB/sql_statement"

g_prepareSqls = {}

g_prepareSqls["HasUsrName"] = SqlStatement:new("HasUsrName")
g_prepareSqls["HasUsrName"]:InitWithSelectCount("user",{"usr_name"})

g_prepareSqls["HasNickName"] = SqlStatement:new("HasNickName")
g_prepareSqls["HasNickName"]:InitWithSelectCount("user",{"nick_name"})

g_prepareSqls["CheckLogin"] = SqlStatement:new("CheckLogin")
g_prepareSqls["CheckLogin"]:InitWithSelect("user",{"uid","submission_date"},{"usr_name","passwd"})

g_prepareSqls["Regist"] = SqlStatement:new("Regist")
g_prepareSqls["Regist"]:InitWithInsert("user",{"usr_name","passwd","nick_name","submission_date"})
g_prepareSqls["Regist"]:AddCmdParam("submission_date")