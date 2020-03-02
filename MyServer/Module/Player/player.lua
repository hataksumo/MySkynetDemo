local skynet = require "skynet"

Player = class()

require "Module/Player/main_city"

function Player:Ctor()
	self.nickName = nil
	self.cityInfo = nil
	self.resbagInfo = nil
	self.addItemCatch = nil
	self.uid = nil
	self.bagMemo = {}
	self.addItemCatch = {}
	self.uniqueItem = {}
end

function Player:InitWithSelectRst(v_uid,v_rst)
	self.uid = v_uid
	self.nickName = v_rst.nick_name
	--local pb_city_info = string.unpack("<s2",v_rst.city_info)
	--local pb_resbag_info = string.unpack("<s2",v_rst.resbag_info)
	self.cityInfo = ProtoSchema:decode("CityInfo",v_rst.city_info)
	self.bagData = ProtoSchema:decode("BagData",v_rst.resbag_info)
	for bagKey,bag in pairs(self.bagData) do
		for _i,itemData in ipairs(bag) do
			self.bagMemo[itemData.id] = {}
			self.bagMemo[itemData.id].bagKey = bagKey
			self.bagMemo[itemData.id].cnt = itemData.cnt
			self.bagMemo[itemData.id].index = _i
		end
	end	
end

function Player:InitWithDefault()
	local cfg_global = sharetable.query("cfg_global")
	self.nickName = "newplayer_"
	self.cityInfo = {
		days = 0,
		clickRes = {
			[1] = {
				id = cfg_global.clickInfo_res_iniIds[1],
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
			[2] = {
				id = cfg_global.clickInfo_res_iniIds[2],
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
			[3] = {
				id = cfg_global.clickInfo_res_iniIds[3],
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
		},
	}
	local cfg_item = sharetable.query("cfg_item")

	self.bagData = {
		currency = {
		},
		bagItem = {
		},
		storage = {
		}
	}
	for _id,data in pairs(cfg_item) do
		local itemType = data.Type
		local the_table = self:GetItemBag(itemType)
		table.insert(the_table,{id = _id,cnt = data.IniVal})
	end
end

function Player:GetItemBag(v_iType)
	if v_iType == 1 then
		return self.bagData.currency
	elseif v_iType == 2 then
		return self.bagData.storage
	elseif v_iType == 3 then
		return self.bagData.bagItem
	elseif v_iType == 5 then
		return self.bagData.bagItem
	end
	return self.uniqueItem
end

function Player:_Save()
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local BagData = ProtoSchema:encode("BagData",self.bagData)
	return cityInfoData,BagData
end


function Player:NewSave(v_nickName)
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local bagData = ProtoSchema:encode("BagData",self.bagData)
	--local pack_cityInfoData = string.pack("<s2",cityInfoData)
	--local pack_bagData = string.pack("<s2",bagData)
	local ok,res = skynet.call(".sql","lua","Querycb","NewPlayer",{g_account.uid,v_nickName,cityInfoData,bagData})
	return ok
end

function Player:Save()
	self:SynchronizeItemInfo()
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local bagData = ProtoSchema:encode("BagData",self.bagData)
	--local pack_cityInfoData = string.pack("<s2",cityInfoData)
	--local pack_bagData = string.pack("<s2",bagData)
	local ok,res = skynet.call(".sql","lua","Query","SavePlayer",{cityInfoData,bagData},{self.uid})
	return ok
end

function Player:AutoSave()
	if not self.m_nSaveTime then
		self.m_nSaveTime = math.random(100*60,100*300)
	end
	skynet.timeout(self.m_nSaveTime, function()  --5分钟存一次
        self:Save()
        self.m_nSaveTime = 100*300;--之后就保存5分钟存一次
        self:AutoSave()
    end)
end

function Player:UpdateTimestamp()
	self:UpdateClickInfo()
end



function Player:AddItems(v_arrAdd)
	for _i,data in ipairs(v_arrAdd) do
		if not self.bagMemo[data.id] then
			print(string.format("Player:AddItems self.bagMemo[%d] = nil\n",data.id)..debug.traceback())
			return
		end
		if not self.addItemCatch[data.id] then
			self.addItemCatch[data.id] = 0
		end
		self.addItemCatch[data.id] = self.addItemCatch[data.id] + data.val

		self.bagMemo[data.id].cnt = self.bagMemo[data.id].cnt + data.val
	end
end

function Player:SynchronizeItemInfo()
	local msg = {}
	msg.changeItems = {}
	for id,addCnt in pairs(self.addItemCatch) do
		local sBagName = self.bagMemo[id].bagKey
		local bag = self.bagData[sBagName]
		if not bag then
			print(string.format("Player:SynchronizeItemInfo: id = %d, self.bagData[%s] = nil",id,sBagName))
			return
		end
		local idx = self.bagMemo[id].index
		local itemData = bag[idx]
		itemData.cnt = self.bagMemo[id].cnt
		local the_msg = {}
		the_msg.id = id
		the_msg.cnt = self.bagMemo[id].cnt
		the_msg.changeCnt = addCnt
		table.insert(msg.changeItems,the_msg)
	end
	self.addItemCatch = {}
	sendMsg(41000,msg)
end