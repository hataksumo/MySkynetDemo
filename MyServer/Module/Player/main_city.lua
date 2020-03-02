function Player:GetClickResInfo(v_iSlot)
	local rtn = {
		awards = g_player:GetClickAward(v_iSlot),
		maxStock = g_player:GetClickResMaxStorage(v_iSlot),
		stock = g_player:GetClickResStorage(v_iSlot),
		recoverTime = g_player:GetRecoverTime(v_iSlot),
		lastUpdateTimeStamp = g_player:GetLastUpdateTimeStamp(v_iSlot)
	}
	--print(print_table(rtn))
	return rtn
end

function Player:GetClickCfgInfo(v_iSlot)
	local cfg_clickResInfo = sharetable.query("cfg_clickResInfo")
	if not self.cityInfo.clickRes[v_iSlot] then
		print(string.format("self.cityInfo.clickRes[%d] = nil",v_iSlot))
	end
	local theClickResInfo = cfg_clickResInfo[self.cityInfo.clickRes[v_iSlot].id]
	return theClickResInfo
end


function Player:GetClickResMaxStorage(v_iSlot)
	local rtn = 0
	--base:
	local theClickResInfo = self:GetClickCfgInfo(v_iSlot)
	rtn = rtn + theClickResInfo.Storage
	--todo:
	--science,governor,or other info
	return rtn
end

function Player:GetClickResStorage(v_iSlot)
	return self:GetClickResMaxStorage(v_iSlot) - self.cityInfo.clickRes[v_iSlot].used
end

function Player:UseResClick(v_iSlot,v_iTimes)
	local storage = self:GetClickResStorage(v_iSlot)
	local maxUse = math.min(storage,v_iTimes)
	self.cityInfo.clickRes[v_iSlot].used = self.cityInfo.clickRes[v_iSlot].used + maxUse
	return maxUse
end

function Player:GetClickAward(v_iSlot)
	local theClickResInfo = self:GetClickCfgInfo(v_iSlot)
	local rtn = {}
	for _i,data in ipairs(theClickResInfo.ClickAward) do
		table.insert(rtn,{id = data.Id,cnt = data.Val})
	end
	return rtn
end

function Player:GetRecoverTime(v_iSlot)
	local theClickResInfo = self:GetClickCfgInfo(v_iSlot)
	return theClickResInfo.RecoverTime
end

function Player:GetLastUpdateTimeStamp(v_iSlot)
	return self.cityInfo.clickRes[v_iSlot].lastUpdateTimeStamp
end

function Player:UpdateClickInfo()
	local timeNow = os.time()
	for _slot=1,3 do
		local recoverTime = self:GetRecoverTime(_slot)
		local maxStock = self:GetClickResMaxStorage(_slot)
		local timeSpan = timeNow - self.cityInfo.clickRes[_slot].lastUpdateTimeStamp
		local recover = maxStock * math.min(timeSpan/recoverTime,1)
		self.cityInfo.clickRes[_slot].used = math.max(0, math.ceil(self.cityInfo.clickRes[_slot].used - recover))
		self.cityInfo.clickRes[_slot].lastUpdateTimeStamp= timeNow
	end
end

function Player:GetDays()
	return self.cityInfo.days
end