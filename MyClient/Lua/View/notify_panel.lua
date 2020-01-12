local transform;
local gameObject;

NotifyPanel = {};
local this = NotifyPanel;

--启动事件--
function NotifyPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;

	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function NotifyPanel.InitPanel()
	this.lblTitle = transform:Find("title/Text").gameObject:GetComponent("Text")
	this.lblContent = transform:Find("content/Text").gameObject:GetComponent("Text")
	this.btnClose = transform:Find("btnClose").gameObject
end

function NotifyPanel.ShowMsg(v_strTitle,v_strContent)
	this.lblTitle.text = v_strTitle
	this.lblContent.text = v_strContent
end

function NotifyPanel.Close()
	panelMgr:Hide("Notify")
end

--单击事件--
function NotifyPanel.OnDestroy()
	logWarn("OnDestroy---->>>")
end

--初始化
function NotifyPanel.init(v_strTitle,v_strContent )
	this.lblTitle.text = v_strTitle
	this.lblContent.text = v_strContent
end
