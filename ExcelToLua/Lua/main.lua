function setPath(v_path)
	package.path = package.path ..";".. v_path.."?.lua"
	print "hello"
end

function main()
	require "tools"
end
