local print_table_str = ""
function print_table(v_t)
	if type(v_t) ~= "table" then
		print("print_table v_t is not table")
		return tostring(v_t)
	end
	print_table_str = ""
	return "{\r\n".._print_table(v_t).."}\r\n"
end

function _print_table(v_t)
	local str = ""
	local bg = true
	for key,val in pairs(v_t) do
		if not bg then
			str = str .. " ,"
		end
		bg = false
		local luaKey = nil
		if type(key) == "string" then
			local firstLetterByte = string.byte(key,1)
			if firstLetterByte >= string.byte('A') and firstLetterByte <= string.byte('Z')
				or firstLetterByte >= string.byte('a') and firstLetterByte <= string.byte('z')
				or firstLetterByte == '_' then
				luaKey = key
			else
				luaKey = "[\""..key.."\"]"
			end
		elseif type(key) == "number" then
			luaKey = '['..key..']'
		end
		if type(val) == "table" then
			str = str..luaKey.." = {\r\n".._print_table(val).."\r\n}"
		else
			str = str..luaKey.." = "..val
		end
	end
	return str
end

function string.IsNullOrEmpty(v_str)
	return v_str == nil or v_str == ""
end

local hexHash = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}

function getHex2(v_num)
	local a1 = hexHash[v_num % 16 + 1]
    v_num = math.floor(v_num / 16)
    local a2 = hexHash[v_num % 16 + 1]
    return a2..a1
end

function getHex4(v_num)
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
		str = str .. getHex2(string.byte(v_str,i))
	end
	return str
end

function string.safeFormat(v_s,...)
	local args = {...}
	local rtn = v_s
	for _i,val in ipairs(args) do
		local safeVal = val
		if type(val) == "table" then
			safeVal = print_table(val)
		else
			safeVal = tostring(val)
		end
		rtn = (string.gsub(rtn,"{".._i.."}",safeVal))
	end
	return rtn
end

StringBuilder = class()
function StringBuilder:Ctor()
	self.data = {}
end

function StringBuilder:Clear()
	self.data = {}
end

function StringBuilder:Append(v_str)
	local len = #v_str
	for i=1,len do
		table.insert(self.data,string.byte(v_str,i))
	end
end

function StringBuilder:ToString()
	local rtn = string.char(table.unpack(self.data))
	return rtn
end