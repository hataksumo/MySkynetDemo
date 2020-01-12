--require "3rd/pblua/login_pb"
--require "3rd/pbc/protobuf"

--local lpeg = require "lpeg"

--local json = require "cjson"
--local util = require "3rd/cjson/util"

--local sproto = require "3rd/sproto/sproto"
--local core = require "sproto.core"
--local print_r = require "3rd/sproto/print_r"
dofile "Controller/ctrl_mgr"
dofile "View/view_mgr"
dofile "Common/functions"
dofile "Common/words_mgr"
abAssetCfg = dofile "Config/asset_cfg"
ctrlCfg = dofile "Config/ctrl_cfg"

--管理器--
Game = {};
local this = Game;
local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;


--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    --注册LuaView--
    CtrlMgr.Init();
    print("test msg")
    Network.InitMsg()

    print("init ok")
    local loginCtrl = CtrlMgr.GetOrCreateCtrl("Login")
    loginCtrl:ShowUnique()
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
