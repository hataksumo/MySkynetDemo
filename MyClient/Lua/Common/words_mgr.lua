_G.LangUtil = {}
LangUtil.Language = function(v_str)
	return v_str
end

local sLanuage = "Cn"
local cfg_words = dofile"Config/words_cfg"
WordMgr = {}
function WordMgr.GetWord(v_iId)
	if not v_iId then
		print("WordMgr.GetWord(nil)")
		return "nil"
	end
	if not cfg_words[v_iId] then
		return "nil"
	end
	return cfg_words[v_iId][sLanuage]
end