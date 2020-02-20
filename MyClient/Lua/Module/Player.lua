Player = class()
function Player:Ctor()
	self.uid = nil
end

function Player:SetUid(v_uid)
	self.uid = v_uid
end

function Player:InitWithPull(v_tMsg)
	self.nick_name = v_tMsg.nick_name
	local rr = string.printByte(v_tMsg.city_info)
	self.city_info = ProtoSchema:decode("CityInfo",v_tMsg.city_info)
	self.resbag_info = ProtoSchema:decode("BagData",v_tMsg.resbag_info)
end