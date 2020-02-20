local OnNetworkCtrl = class(CtrlBase)

function OnNetworkCtrl:Ctor()
	self.iOnRequest = 0
	self.CMDS["BeginRequest"] = OnNetworkCtrl.BeginRequest
	self.CMDS["EndRequest"] = OnNetworkCtrl.EndRequest
	self.ft = 0
	self.MAX_PENDING = 5
end

function OnNetworkCtrl:BeginRequest(v_oSender)
	if self.iOnRequest == 0 then
		self:ShowView("OnNetwork")
		self:_Start()
	end
	self.iOnRequest = self.iOnRequest + 1
	--print("BeginRequest self.iOnRequest = "..self.iOnRequest..debug.traceback())
end

function OnNetworkCtrl:EndRequest(v_oSender)
	self.iOnRequest = math.max(self.iOnRequest - 1,0)
	if self.iOnRequest == 0 then	
		self:_End()
	end
	--print("EndRequest self.iOnRequest = "..self.iOnRequest..debug.traceback())
end

function OnNetworkCtrl:Prepare()
	self:PrepareView("OnNetwork")
end

function OnNetworkCtrl:_Start()
	self:RegistUpdate("OnNetwork")
	self.ft = 0
end

function OnNetworkCtrl:_End()
	ViewMgr.HideView("OnNetwork")
	self:RemoveUpdate("OnNetwork")
end

function OnNetworkCtrl:OnUpdate(v_dt)
	self.ft = self.ft + v_dt
	self:SendViewMsg("OnNetwork","Update",self.ft)
	if self.ft > self.MAX_PENDING then
		self.iOnRequest = 0
		self:_End()
	end
end

return OnNetworkCtrl