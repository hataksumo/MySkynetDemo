local skynet = require "skynet"
require "skynet.manager"  -- import skynet.register
local mysql = require "skynet.db.mysql"
require "DB/sql_statements"

local db
local CMD = {}

function CMD.start()
    print("------mysql--CMD.start:");
    for key,statement in pairs(g_prepareSqls) do
        local prepare = statement:GetPrepareSql()
        local rtn = nil
        local ok,err = pcall(function()
             rtn = db:query(prepare)
        end)
        if not ok then
            print("An error occured when prepare "..key..". errmsg is: \n"..err)
        else
            --print(prepare)
            if rtn.badresult then
                print(rtn.err)
            else
               --print("prepare "..key.." ok \n") 
            end  
        end
        
        
    end
    return "start return"
end
--sqlres1  {errno=1064,sqlstate="42000",err="You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '{[\\\"1601307937324765076\\\"]={[1]=\\\"1\\\",[2]=\\\"1\\\",[3]=\\\"360\\\",},}'' WHERE rl_uID=1' at line 1",badresult=true,}  
local function _safeQuery(v_sql)
    if not v_sql then
        return false,nil
    end


    local res = nil
    local ok,errMsg = pcall(function()
        res = db:query(v_sql)
        --print(v_sql)
    end
    )
    if not ok then
        debug.traceback()
        print("An error occured when call CMD.Querycb. errmsg is:\n"..errMsg or "nil")
        return false,errMsg
    end

    if res.badresult then
        print("sql : "..v_sql)
        print("errmsg is "..res.err)
        return false,res.err
    end 
    --print(print_table(res))
    return true,res
end

local function batchParam(...)
    local rtn = {}
    local params = {...}
    for _i,arrParam in ipairs(params) do
        Array.Merge(rtn,arrParam)
    end
    return rtn
end


function CMD.Query(v_sSqlStatementKey,...)
    local statement = g_prepareSqls[v_sSqlStatementKey]
    if statement == nil then
        print("can't find statement keyed "..v_sSqlStatementKey)
        return
    end
    local params = batchParam(...)
    skynet.fork(function() 
        local ok,res = _safeQuery(statement:GetExecutePrepareSql(params))
        --print(print_table(res))
    end)
end

function CMD.Querycb(v_sSqlStatementKey,...)
    local statement = g_prepareSqls[v_sSqlStatementKey]
    if statement == nil then
        print("can't find statement keyed "..v_sSqlStatementKey)
        return
    end
    local params = batchParam(...)
    local ok,res = _safeQuery(statement:GetExecutePrepareSql(params))
    if ok then
        local rtn = statement:GetResult(res)
        return true,rtn
    else
        return false,res
    end
end

skynet.start(function(v_cfg)
    --local sqlname = skynet.getenv "sqlname"
    --if not sqlname then sqlname = 'skynetheros' end;
    local function on_connect(db)
      print("db connected")
      db:query("set charset utf8");
    end
    --print("==========begin connect===============")
    local rst,err = pcall(function()
       db=mysql.connect({
        host="192.168.1.3",
        port= 3306,
        database="civil",
        user= "gameserver",
        password= "qqhilvMgAl7_1124",
        max_packet_size = 1024 * 1024,
        on_connect = on_connect
    })
    end)

    if not rst then
        print("err "..err or "nil")
    end
    
    --print("===============finished===============")
	if not db then
		print("failed to connect mysql")
	end
	db:query("set names utf8")
    --
    skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		local f = assert(CMD[cmd],"can't find "..cmd.." in CMD")
        if session == 0 then 
            f(subcmd, ...)
        else 
		    skynet.ret(skynet.pack(f(subcmd, ...)))
        end
	 end)
    skynet.register ".sql"
end)

