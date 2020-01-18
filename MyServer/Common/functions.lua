
LangUtil = {}
function LangUtil.Language(v_str)
	return v_str
end

Array = {}

function Array.Merge(v_tarrDst,v_tarrOrg)
	if v_tarrOrg == nil then
		print("v_tarrOrg = nil")
		debug.trace()
		return
	end
	for _i,val in ipairs(v_tarrOrg) do
		table.insert(v_tarrDst,val)
	end
end