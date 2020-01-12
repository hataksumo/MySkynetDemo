local playerId = nil

local Account = {}
local this = Account

Account.IsLogin = function()
	return not playerId
end

return this