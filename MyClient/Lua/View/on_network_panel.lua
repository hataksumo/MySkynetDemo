local OnNetworkView = class(ViewBase)

function OnNetworkView:Ctor()
	self.INTEVAL = 0.125
	self.CMDS["Update"] = OnNetworkView.Update
	-- for key,fn in pairs(math) do
	-- 	if type(fn) == "function" then
	-- 		print("function "..key)
	-- 	end
	-- end
end

function OnNetworkView:_OnInit()
	self.tarrShowBars = {self.comImgSlice1,self.comImgSlice2,self.comImgSlice3,self.comImgSlice4,
	self.comImgSlice5,self.comImgSlice6,self.comImgSlice7,self.comImgSlice8}
end


function OnNetworkView:Update(v_oSender,v_ft)
	local iSelectBar = math.fmod(math.floor(v_ft / self.INTEVAL),#self.tarrShowBars) + 1
	for _i,comImgBar in ipairs(self.tarrShowBars) do
		local c = Color.New(0.6226415, 0.6020826, 0.6020826, 1)
		comImgBar.color = c
	end
	local c = Color.New(0.2224101, 0.9245283, 0.8628, 1)
	self.tarrShowBars[iSelectBar].color = c
end

return OnNetworkView