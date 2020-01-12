_G.fn_creat_arr = function(v_set)
    local rtn = {}
    for key, val in pairs(v_set) do
        table.insert(rtn, val)
    end
    return rtn
end

_G.fn_creat_skillArr = function(v_set)
	local arr = fn_creat_arr(v_set)
	table.sort(arr,function(v_left,v_right)
		if v_left.pri and v_right.pri and v_left.pri ~= v_right.pri then
			return v_left.pri < v_right.pri
		end
		if v_left.layer and v_right.layer then
			return v_left.layer < v_right.layer
		end
		return false
	end)
	return arr
end