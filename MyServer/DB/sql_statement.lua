local skynet = require "skynet"
local mysql = require "skynet.db.mysql"

local SqlStatement = class()

function SqlStatement:Ctor(v_name,v_bSingleRow)
	if v_bSingleRow == nil then
		v_bSingleRow = true
	end
	self.bSingleRow = v_bSingleRow
	self.sSql = nil
	self.sName = v_name
	self.tParams = {}
	self.iExecuteCnt = 0
	self.arrCmdKey = {}
end

function SqlStatement:InitWithSql(v_sSql,v_arrParam)
	self.sSql = v_sSql
	Array.Merge(self.tParams,v_arrParam)
end

function SqlStatement:AddCmdParam(...)
	local v_arrCmdParam = {...}
	for _i,val in ipairs(v_arrCmdParam) do
		self.arrCmdKey[val] = true
	end
end

function SqlStatement:InitWithInsert(v_sTable,v_arrParam)
	local sb = StringBuilder:new()
	sb:Append("INSERT INTO ")
	sb:Append(v_sTable)
	sb:Append("(")
	local paramLen = #v_arrParam
	for _i,val in ipairs(v_arrParam) do
		sb:Append(val)
		if _i < paramLen then
			sb:Append(",")
		end
	end
	sb:Append(") VALUES(")
	for _i,val in ipairs(v_arrParam) do
		sb:Append("?")
		if _i < paramLen then
			sb:Append(",")
		end
	end
	sb:Append(")")
	self.sSql = sb:ToString()

	Array.Merge(self.tParams,v_arrParam)
end

function SqlStatement:InitWithUpdate(v_sTable,v_arrSetParam,v_arrWhere)
	local sb = StringBuilder:new()
	sb:Append("UPDATE ")
	sb:Append(v_sTable)
	sb:Append(" SET ")
	local setParamLen = #v_arrSetParam
	for _i,val in ipairs(v_arrSetParam) do
		sb:Append(val)
		sb:Append(" = ")
		sb:Append("?")
		if _i < setParamLen then
			sb:Append(",")
		end
	end
	sb:Append(" WHERE ")
	local whereParamLen = #v_arrWhere
	for _i,val in ipairs(v_arrWhere) do
		sb:Append(val)
		sb:Append(" = ")
		sb:Append("?")
		if _i < whereParamLen then
			sb:Append(" AND ")
		end
	end
	self.sSql = sb:ToString()

	Array.Merge(self.tParams,v_arrSetParam)
	Array.Merge(self.tParams,v_arrWhere)
end

function SqlStatement:InitWithSelect(v_sTable,v_arrSetParam,v_arrWhere,v_bCnt)
	if v_bCnt == nil then
		v_bCnt = false
	end
	local sb = StringBuilder:new()
	sb:Append("SELECT ")
	if v_bCnt then
		sb:Append("COUNT(*) as `cnt`, ")
	end
	local setParamLen = #v_arrSetParam
	for _i,val in ipairs(v_arrSetParam) do
		sb:Append(val)
		if _i < setParamLen then
			sb:Append(",")
		end
	end
	sb:Append(" FROM ")
	sb:Append(v_sTable)
	sb:Append(" WHERE ")
	local whereParamLen = #v_arrWhere
	for _i,val in ipairs(v_arrWhere) do
		sb:Append(val)
		sb:Append(" = ")
		sb:Append("?")
		if _i < whereParamLen then
			sb:Append(" AND ")
		end
	end
	self.sSql = sb:ToString()
	Array.Merge(self.tParams,v_arrWhere)
end

function SqlStatement:InitWithSelectCount(v_sTable,v_arrWhere)
	local sb = StringBuilder:new()
	sb:Append("SELECT COUNT(*) as `cnt`")
	sb:Append(" FROM ")
	sb:Append(v_sTable)
	sb:Append(" WHERE ")
	local whereParamLen = #v_arrWhere
	for _i,val in ipairs(v_arrWhere) do
		sb:Append(val)
		sb:Append(" = ")
		sb:Append("?")
		if _i < whereParamLen then
			sb:Append(" AND ")
		end
	end
	self.sSql = sb:ToString()
	Array.Merge(self.tParams,v_arrWhere)
end


function SqlStatement:GetPrepareSql()
	--local sql = string.format("PREPARE %s FROM '%s'",self.sName,self.sSql)
	--skynet.send(".sql","lua","Prepare",sql)
	return string.format("PREPARE %s FROM '%s'",self.sName,self.sSql)
end


function SqlStatement:GetExecutePrepareSql(...)
	local params = {...}
	local paramArr = {}
	for _i,subParamArr in ipairs(params) do
		for _j,param in ipairs(subParamArr) do
			table.insert(paramArr,param)
		end
	end

	if #self.tParams ~= #paramArr then
		print(self.sName.." the number of param must be "..#self.tParams.." but your params are "..print_table(paramArr))
		return nil
	end
	--assert(#self.tParams == #paramArr,self.sName.." the number of param must be "..#self.tParams.." but your params are "..print_table(paramArr))
	self.iExecuteCnt = 0
	local len = #paramArr
	local sb = StringBuilder:new()
	for _i,paramName in ipairs(self.tParams) do
		local val = paramArr[_i]
		if type(val) == "number" then
			sb:Append(string.format("SET @%s = %s;\n",paramName,val))
		elseif type(val) == "string" then
			if self.arrCmdKey[paramName] then
				sb:Append(string.format("SET @%s = %s;\n",paramName,val))
			else
				sb:Append(string.format("SET @%s = %s;\n",paramName,mysql.quote_sql_str(val)))
			end			
		else
			error("SqlStatement:ExecutePrepare, type illegal "..(val or "nil"))
		end
		self.iExecuteCnt = self.iExecuteCnt + 1
	end
	sb:Append(string.format("EXECUTE %s USING ",self.sName))
	for _i,val in ipairs(self.tParams) do
		sb:Append("@")
		sb:Append(val)
		if _i < len then
			sb:Append(", ")
		end
	end
	sb:Append(";")
	self.iExecuteCnt = self.iExecuteCnt + 1
	local sql = sb:ToString()
	return sql
	
end


function SqlStatement:GetResult(v_rtn)
	local tarTable = v_rtn[self.iExecuteCnt]
	if self.bSingleRow then
		return tarTable[1]
	else
		return tarTable
	end
end

return SqlStatement