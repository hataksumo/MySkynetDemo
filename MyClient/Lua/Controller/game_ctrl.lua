local GameCtrl = class(CtrlBase)

function GameCtrl:Ctor()
	
end

function GameCtrl:Start()
	self:AddSocketListener(41000,self.OnNetRspResChange)
	self:AddSocketListener(40002,self.OnNetHeartBeat)
end

function GameCtrl:OnNetRspResChange(v_tMsg)
	gPlayer:Synchronize(v_tMsg)
end

function GameCtrl:OnNetHeartBeat(v_tMsg)
	Game.UpdateServTime(v_tMsg.srvTime)
end

return GameCtrl