
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


function table.cloneArr(v_dst,v_src)
	local newClone = {}
	for _i,val in ipairs(v_src) do
		table.insert(v_dst,val)
	end
	return newClone
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

local cfg_global
function GetGlobalVar(v_key)
	if not cfg_global[v_key] then
		logError("don't have "..(v_key or "nil").." in global")
		return nil
	end
	return cfg_global[v_key]
end

local init = function()
	cfg_global = dofile("Config/global")
end

return init