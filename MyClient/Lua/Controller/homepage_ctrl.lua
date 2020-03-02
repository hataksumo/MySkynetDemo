local HomepageCtrl = class(CtrlBase)

local GATHER_INTEVAL = 0.1
local SENDMSG_BATCH_TIME = 1
local CLICKRES_UPDATE_INTEVAL = 0.5

function HomepageCtrl:Ctor()
	self.CMDS["GoBackLogin"] = self.OnCmdGoBackLogin
	self.CMDS["BeginGather"] = self.OnCmdBeginGather
	self.CMDS["EndGather"] = self.OnCmdEndGather
	--网络消息
	self:AddSocketListener(40001,self.OnNetBackLogin)
	self:AddSocketListener(40040,self.OnNetRspGather)
	self:AddSocketListener(41000,self.OnNetRspResChange,false)
	--搜集资源功能所用变量
	self._fGatherTime = 0
	self._fTouchDownTime = 0
	self._iCurSlot = -1
	self._iClickTimes = 0
	self._bBeginGather = false
	self._fClickResUpdateTime = 0
end

function HomepageCtrl:OnCmdGoBackLogin(v_oSender)
	Network.SendMsg(10001,{account_id = gAccount.uid})
end

function HomepageCtrl:Start() 
	self:ShowUniqueView("HomePage")
	self:SendViewMsg("HomePage","InitRes",{[101] = gPlayer:GetItemStorage(101),[102] = gPlayer:GetItemStorage(102),[103] = gPlayer:GetItemStorage(103)})
	self:SendViewMsg("HomePage","InitClickRes",{[1] = gPlayer:GetClickResSlotInfo(1),[2] = gPlayer:GetClickResSlotInfo(2),[3] = gPlayer:GetClickResSlotInfo(3)})
	self:RegistUpdate("ClickResUpdate",self.OnClickResUpdate)
end


function HomepageCtrl:OnNetBackLogin(v_tMsg)
	if v_tMsg and v_tMsg.code == 1 then
		local loginCtrl = CtrlMgr.GetOrCreateCtrl("Login")
	    loginCtrl:Start()
	    loginCtrl:Reset()
	end
end

function HomepageCtrl:OnNetRspGather(v_tMsg)
	--print("v_tMsg.slot = ",v_tMsg.slot," v_tMsg.stock = ",v_tMsg.stock)
	gPlayer:SetClickResSlotStorage(v_tMsg.slot,v_tMsg.clickResInfo,v_tMsg.stock)
	self:SendViewMsg("HomePage","UpdateClickRes",{gPlayer:GetClickResSlotInfo(1),gPlayer:GetClickResSlotInfo(2),gPlayer:GetClickResSlotInfo(3)})
end

function HomepageCtrl:OnNetRspResChange(v_tMsg)
	local concernRes = {
		[101] = {
			cnt = gPlayer:GetItemStorage(101)
		},
		[102] = {
			cnt = gPlayer:GetItemStorage(102)
		},
		[103] = {
			cnt = gPlayer:GetItemStorage(103)
		}
	}
	for _i,data in ipairs(v_tMsg.changeItems) do
		concernRes[data.id].cnt = data.cnt
		concernRes[data.id].changeCnt = data.changeCnt
	end
	self:SendViewMsg("HomePage","ResChange",concernRes)
end


function HomepageCtrl:_BeginGatherTouchDown()
	--print("HomepageCtrl:_BeginGatherTouchDown")
	self._TouchDownTime = 0
	self:RegistUpdate("OnGatherUpdate",self.OnGatherUpdate)
end

function HomepageCtrl:_EndGatherTouchDown()
	--print("HomepageCtrl:_EndGatherTouchDown")
	self._TouchDownTime = 0
	self:RemoveUpdate("OnGatherUpdate",self.OnGatherUpdate)
end

function HomepageCtrl:_BeginGather()
	--print("HomepageCtrl:_BeginGather")
	self._GatherTime = 0
	self:RegistUpdate("OnBatchGatherUpdate",self.OnBatchGatherUpdate)
end

function HomepageCtrl:_EndGather()
	--print("HomepageCtrl:_EndGather")
	self:_SendBatch()
	self:RemoveUpdate("OnBatchGatherUpdate")
	self._GatherTime = 0
	self._iCurSlot = -1
	self._bBeginGather = false
end

--没有新的操作1秒或更换slot
function HomepageCtrl:_SendBatch()
	--print("HomepageCtrl:_SendBatch slot = "..self._iCurSlot.." clickTimes = "..self._iClickTimes)
	Network.SendMsg(10040,{slot = self._iCurSlot,clickTimes = self._iClickTimes})
	self._iClickTimes = 0
end

function HomepageCtrl:_GatherOne()
	local storage = gPlayer:GetClickResSlotStorage(self._iCurSlot)
	--print("storage = "..(storage or "nil").." self._iClickTimes = "..print_table(self._iClickTimes))
	if storage > self._iClickTimes then
		self._iClickTimes = self._iClickTimes + 1
		local the_info = gPlayer:GetClickResSlotInfo(self._iCurSlot)
		local addRes = {}
		for _i,data in ipairs(the_info.awards) do
			table.insert(addRes,{id = data.id, val = data.cnt * self._iClickTimes + gPlayer:GetItemStorage(data.id)})
		end
		self:SendViewMsg("HomePage","TempReactClickRes",self._iCurSlot,addRes,gPlayer:GetClickResProcess(self._iCurSlot,self._iClickTimes))
	end
end

function HomepageCtrl:OnCmdBeginGather(v_oSender,v_iSlot)
	if v_iSlot ~= self._iCurSlot then
		if self._iCurSlot == -1 then
			self._iCurSlot = v_iSlot
		else
			self:_SendBatch()
			self._iCurSlot = v_iSlot
			self._fGatherTime = 0
		end
	end
	self:_BeginGatherTouchDown()
	if not self._bBeginGather then
		self._bBeginGather = true
		self:_BeginGather()
	end
end

function HomepageCtrl:OnCmdEndGather(v_oSender,v_iSlot)
	self:_EndGatherTouchDown()
end

function HomepageCtrl:OnGatherUpdate(v_dt)
	local newTime = self._TouchDownTime + v_dt
	if math.floor(newTime / GATHER_INTEVAL) > math.floor(self._TouchDownTime / GATHER_INTEVAL) then
		self:_GatherOne()
	end
	self._TouchDownTime = newTime
	self._GatherTime = 0
end

function HomepageCtrl:OnBatchGatherUpdate(v_dt)
	local newTime = self._GatherTime + v_dt
	if math.floor(newTime / SENDMSG_BATCH_TIME) > math.floor(self._GatherTime / SENDMSG_BATCH_TIME) then
		self:_EndGather()
	end
	self._GatherTime = newTime
end

function HomepageCtrl:OnClickResUpdate(v_t)
	local newTime = self._fClickResUpdateTime + v_t
	if math.floor(newTime / CLICKRES_UPDATE_INTEVAL) > math.floor(self._fClickResUpdateTime / CLICKRES_UPDATE_INTEVAL) then
		local process = {}
		for _slot=1,3 do
			if _slot == self._iCurSlot then
				process[_slot] = gPlayer:GetClickResProcess(_slot,self._iClickTimes)
			else
				process[_slot] = gPlayer:GetClickResProcess(_slot)
			end		
		end
		self:SendViewMsg("HomePage","UpdateClickResProcess",process)
	end
	self._fClickResUpdateTime = newTime
end


return HomepageCtrl