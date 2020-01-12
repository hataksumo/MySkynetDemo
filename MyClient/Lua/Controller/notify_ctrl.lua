NotifyCtrl = {};
local this = NotifyCtrl;

local behaviour;
local transform;
local gameObject;

--构建函数--
function NotifyCtrl.New()
	logWarn("NotifyCtrl.New--->>");
	return this;
end

function NotifyCtrl.Awake()
	logWarn("NotifyCtrl.Awake--->>");
	panelMgr:CreatePanel("Notify", this.OnCreate);
end

function NotifyCtrl.Show(v_strTitle,v_strContent)
	NotifyPanel.init(v_strTitle,v_strContent)
	panelMgr:Show("Notify")
end

--启动事件--
function NotifyCtrl.OnCreate(obj)
	gameObject = obj;
	behaviour = gameObject:GetComponent('LuaBehaviour');
	behaviour:AddClick(NotifyPanel.btnClose, this.Close);
	panelMgr:Hide("Notify")
	--logWarn("Start lua--->>"..gameObject.name);
end

--关闭事件--
function NotifyCtrl.Close()
	NotifyPanel.Close()
end