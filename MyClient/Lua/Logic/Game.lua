ddt = {}
dofile "Common/words_mgr"
dofile "Controller/ctrl_mgr"
dofile "View/view_mgr"
local functions_init = dofile "Common/functions"
dofile "Common/string_funs"
dofile "Module/Player"

abAssetCfg = dofile "Config/asset_cfg"
ctrlCfg = dofile "Config/ctrl_cfg"

--管理器--
Game = {};
local this = Game;
local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;
gAccount = dofile "Module/Account"
gPlayer = nil
local tListeners = {}



--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
	functions_init()
    --注册LuaView--
    CtrlMgr.Init();
    --print("test msg")
    Network.InitMsg()
    --print("init ok")
    local gameCtrl = CtrlMgr.GetOrCreateCtrl("Game")
    gameCtrl:Start()

    local loginCtrl = CtrlMgr.GetOrCreateCtrl("Login")
    loginCtrl:Start()
    -- ViewMgr.CreatePanel("Login")
    -- ViewMgr.CreatePanel("Login")
    -- CtrlMgr.SendMsg("Login","Exit",Game)
end

--[[
框架规则：
View层负责绑定各控件，做动画效果
Controller层负责响应View层和其他模块发来的消息
Module层负责记录玩家的数据
每个Panel有个NickName，在表中配置他对应的Ctrl和View
所有的View和Ctrl都是class
]]


--销毁--
function Game.OnDestroy()
	--logWarn('OnDestroy--->>>');
end

function Game.OnUpdate(v_dt)
	for _key,oListenObject in pairs(tListeners) do
		--print("Update ext key ".._key)
		if type(oListenObject) == "function" then
			oListenObject(v_dt)
		else
			oListenObject.callBack(oListenObject.listener,v_dt)
		end
	end
end

function Game.AddUpdateListerner(v_key,v_oListerner,v_fnCallback)
	if tListeners[v_key] then
		logError("Game.AddListerner "..v_key.."has been registed")
		return
	end
	if type(v_oListerner) == "function" then
		tListeners[v_key] = v_oListerner
	elseif IsObject(v_oListerner) then
		if not v_fnCallback then
			logError("Game.AddUpdateListerner callBack is nil")
			return
		end
		tListeners[v_key] = {listener = v_oListerner,callBack = v_fnCallback}
	else
		logError("Game.AddUpdateListerner binding param is illicit")
	end
	
end

function Game.RemoveUpdateListener(v_key)
	tListeners[v_key] = nil
end

function Game.Debug(v_str)
	print(v_str.."\n"..debug.traceback())
end

local servetTimeDif = 0
function Game.GetServetTime()
	return os.time() + servetTimeDif
end

function Game.UpdateServTime(v_iSrvTime)
	servetTimeDif = v_iSrvTime - os.time()
end