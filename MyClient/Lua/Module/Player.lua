Player = class()
function Player:Ctor()
	self.uid = nil
end

function Player:SetUid(v_uid)
	self.uid = v_uid
end

function Player:InitWithPull(v_tMsg)
	self.nick_name = v_tMsg.nick_name
	local city_info = ProtoSchema:decode("CityInfo",v_tMsg.db_city_info)
	local resbag_info = ProtoSchema:decode("BagData",v_tMsg.db_resbag_info)
	self.sBagInfo = {}
	local sTypeHash = {
		[1] = "currency",
		[2] = "storage",
		[3] = "bagItem",
		--[4] = "equiptItem",
		[5] = "bagItem"
	}
	for _i,field in pairs(sTypeHash) do
		local bagTable = resbag_info[field]
		if bagTable then
			for _j,info in ipairs(bagTable) do
				self.sBagInfo[info.id] = info.cnt
			end
		end
	end
	self.city_view = v_tMsg.view_city_info
end

function Player:GetClickResSlotInfo(v_iSlot)
	return self.city_view.clickRes[v_iSlot]
end

function Player:GetClickResSlotStorage(v_iSlot)
	return self.city_view.clickRes[v_iSlot].stock
end

function Player:GetCityClickAward(v_iSlot)
	return self.city_view.clickRes[v_iSlot].awards
end

function Player:SetClickResSlotStorage(v_iSlot,v_tClickResInfo)
	self.city_view.clickRes[v_iSlot] = v_tClickResInfo
end

function Player:GetClickResProcess(v_iSlot,v_iTmpUsed)
	v_iTmpUsed = v_iTmpUsed or 0
	local slotInfo = self.city_view.clickRes[v_iSlot]
	local recoverTime = slotInfo.recoverTime
	local timeSpan = Game.GetServetTime() - slotInfo.lastUpdateTimeStamp
	local recover = math.floor(slotInfo.maxStock * math.min(timeSpan/recoverTime,1))
	return math.min(1,(slotInfo.stock - v_iTmpUsed + recover) / slotInfo.maxStock)
end


function Player:GetItemStorage(v_iItemId)
	if not self.sBagInfo[v_iItemId] then
		Game.Debug("can't find "..v_iItemId.." in self.sBagInfo")
		return nil
	end
	return self.sBagInfo[v_iItemId]
end

function Player:Synchronize(v_tMsg)
	for _i,data in ipairs(v_tMsg.changeItems) do
		self.sBagInfo[data.id] = data.cnt
	end	
end

