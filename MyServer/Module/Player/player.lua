local skynet = require "skynet"

Player = class()

function Player:Ctor()
	self.nickName = nil
	self.cityInfo = nil
	self.resbagInfo = nil
	self.dirty = false
end

function Player:InitWithSelectRst(v_rst)
	self.nickName = v_rst.nick_name
	local pb_city_info = string.unpack("<s2",v_rst.city_info)
	local pb_resbag_info = string.unpack("<s2",v_rst.resbag_info)

	self.cityInfo = ProtoSchema:decode("CityInfo",pb_city_info)
	self.resbagInfo = ProtoSchema:decode("BagData",pb_resbag_info)
end

function Player:InitWithDefault()
	self.nickName = "newplayer_"
	self.cityInfo = {
		days = 0,
		clickRes = {
			[1] = {
				id = 101,
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
			[2] = {
				id = 102,
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
			[3] = {
				id = 103,
				used = 0,
				lastUpdateTimeStamp = os.time()
			},
		},
	}

	local cfg_item = sharetable.query("cfg_item")

	self.BagData = {
		currency = {
		},
		bagItem = {
		},
		equiptItem = {
		},
		storage = {
		}
	}

	for _id,data in pairs(cfg_item) do
		local itemType = data.Type
		local iniVal = data.iniVal
		local the_table = {}
		if itemType == 1 then
			the_table = self.BagData.currency
		elseif itemType == 2 then
			the_table = self.BagData.storage
		elseif itemType == 3 then
			the_table = self.BagData.bagItem
		elseif itemType == 4 then
			the_table = self.BagData.equiptItem
		elseif itemType == 5 then
			the_table = self.BagData.bagItem
		end
		table.insert(the_table,{id = _id,cnt = iniVal})
	end

end

function Player:_Save()
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local BagData = ProtoSchema:encode("BagData",self.BagData)
	return cityInfoData,BagData
end


function Player:NewSave(v_nickName)
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local bagData = ProtoSchema:encode("BagData",self.BagData)
	local pack_cityInfoData = string.pack("<s2",cityInfoData)
	local pack_bagData = string.pack("<s2",bagData)

	local ok,res = skynet.call(".sql","lua","Querycb","NewPlayer",{g_account.uid,v_nickName,pack_cityInfoData,pack_bagData})
	return ok
end

function Player:Save()
	local cityInfoData = ProtoSchema:encode("CityInfo",self.cityInfo)
	local bagData = ProtoSchema:encode("BagData",self.BagData)
	local pack_cityInfoData = string.pack("<s2",cityInfoData)
	local pack_bagData = string.pack("<s2",pack_bagData)
	local ok,res = skynet.call(".sql","lua","Query","SavePlayer",{pack_cityInfoData,pack_bagData},{self.uid})
	return ok
end

function Player:AutoSave()
	if not self.m_nSaveTime then
		self.m_nSaveTime = math.random(100*60,100*300)
	end
	skynet.timeout(self.m_nSaveTime, function()  --5分钟存一次
        self.Save()
        self.m_nSaveTime = 100*300;--之后就保存5分钟存一次
        self.AutoSave()
    end)
end
