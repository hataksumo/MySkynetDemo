require "Tools"


function test()
	init()
	print("testOK")
end


function Main()
	-- body
end

--excel_path_root = AppContest.AssetPath.."\\..\\Excel\\"--excel表的目录

function SetLooseReadonly(v_cfg)
	-- body
end

function init()
	require "lua_class"
	_G.ddt = {}
	require "tools"
	require "Logic/Property"
end


function output_excel()
	local output = {
	--"Excel\\DropOutput",
	--"Excel\\BattleCameraOutput",
	--"Excel\\jhmOutput"
	--"Excel\\NewDropOutput"
	"Excel\\PropBsOutput"
	--"Excel\\GuaJiPaiQian"
	--"Excel\\RelicAct"
	}
	for _i,val in ipairs(output) do
		local fn = dofile(val)
		if type(fn) == "function" then
			fn()
		elseif type(fn) == "string" then
			ZFDebug.Error(string.format("执行%s文件时报错了，报错信息为:\r\n%s",val,fn))
		else
			ZFDebug.Error(string.format("执行%s文件时返回为空，信息为:\r\n%s",val,fn))
		end

		ZFDebug.Koid(string.format("%s导出完成",val))
	end
	ZFDebug.Koid("哈哈，导出完成")
end

function CompileSproto()
	local sprotoParser = require "3rd/sproto/sprotoparser"
	local schemaC2S = dofile "message_c2s"
	local schemaS2C = dofile "message_s2c"
	local schemaDB = dofile "db_data"
	local sproto = require "3rd/sproto/sproto"
	local schema = schemaC2S .. schemaS2C .. schemaDB
	local pb = sprotoParser.parse(schema)
	local ok = sproto.parse(schema)
	if not ok then
		print(schema)
	end
	local ok2 = sproto.new(pb)
	if ok2 then
		print("ok2")
	end

	local file = io.open(MyTools.MessagePath.."Message.pb","w")
	file:write(pb)
	file:close()
end