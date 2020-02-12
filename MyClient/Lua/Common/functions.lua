
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str.."\r\n"..debug.traceback());
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

local hexHash = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}

function getHex(v_num)
    local a1 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a2 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a3 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a4 = hexHash[v_num % 16 + 1]
    return a4..a3..a2..a1
end

function print_buffer(v_buffer)
	local len = v_buffer.Length
	local pt = {}
	for i=0,len-1 do
		table.insert(pt,getHex(v_buffer[i]))
	end
	print(table.concat(pt," "))
end

function print_raw_string(v_string)
	local tt = {}
	for i=1,#v_string do
		table.insert(tt,string.byte(v_string,i))
	end
	print(table.concat(tt," "))
end

function table.cloneArr(v_dst,v_src)
	local newClone = {}
	for _i,val in ipairs(v_src) do
		table.insert(v_dst,val)
	end
	return newClone
end

local print_table_str = ""
function print_table(v_t)
	print_table_str = ""
	return "{\r\n".._print_table(v_t).."}\r\n"
end

function _print_table(v_t)
	local str = ""
	for key,val in pairs(v_t) do
		if type(val) == "table" then
			str = str..key.." = {\r\n".._print_table(val).."\r\n},"
		else
			str = str..key.." = "..(val or "nil")..", "
		end
	end
	return str
end

function string.IsNullOrEmpty(v_str)
	return v_str == nil or v_str == ""
end


local hexHash = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}

function getHex(v_num)
    local a1 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a2 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a3 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a4 = hexHash[v_num % 16 + 1]
    return a4..a3..a2..a1
end

function string.printByte(v_str)
	local str = ""
	local len = string.len(v_str)
	for i=1,len do
		if i > 1 then
			str = str.." "
		end
		str = str .. string.byte(v_str,i)
	end
	return str
end

function IsObject(v_tester)
	if v_tester.__tbl_Baseclass__ then
		return true
	end
	return false
end

function table.getCnt(v_t)
	local cnt = 0
	for key,val in pairs(v_t) do
		cnt = cnt + 1
	end
	return cnt
end