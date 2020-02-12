local Account = {}
local this = Account
local _uid = nil

function Account.InitWithLogin(v_iUid)
	_uid = v_iUid
end

function Account.GetUid()
	return _uid
end

return this