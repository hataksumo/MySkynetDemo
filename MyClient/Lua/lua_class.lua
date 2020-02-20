--[[
lua class
特性：
支持继承及多重继承
支持类型检测
支持构造函数
符合面向对象的的编程思维模式
继承关系复杂不再影响性能，但是失去了reload
]]


local ClassDefineMt = {}
function ClassDefineMt.__index( tbl, key )
	local tBaseClass = tbl.__tbl_Baseclass__
	for i = 1, #tBaseClass do
		local xValue = rawget(tBaseClass[i],key)
		if xValue then
			rawset( tbl, key, xValue )
			return xValue
		end
	end
    print("can't find "..key.." in table\n"..debug.traceback())
end

        
function class( ... )
	local arg = {...}
    local ClassDefine = {}
    
    -- 这里是把所有的基类放到 ClassDefine.__tbl_Bseclass__ 里面
    ClassDefine.__tbl_Baseclass__ =  {}
    for index = 1, #arg do
    	local tBaseClass = arg[index]
        table.insert(ClassDefine.__tbl_Baseclass__, tBaseClass)
        
        for i = 1, #tBaseClass.__tbl_Baseclass__ do
        	table.insert(ClassDefine.__tbl_Baseclass__, tBaseClass.__tbl_Baseclass__[i])
        end
    end
    
    -- 所有对实例对象的访问都会访问转到ClassDefine上
    local InstanceMt =  { __index = ClassDefine }
    
       --  IsClass 函数提供对象是否某种类型的检测, 支持多重继承
    ClassDefine.IsClass = function(self, classtype)
        local bIsType = (self == classtype)
        if bIsType then
            return bIsType
        end
        
        for index=1, #self.__tbl_Baseclass__ do
            local baseclass = self.__tbl_Baseclass__[index]
            bIsType =  (baseclass == classtype)
            if bIsType then
                return bIsType
            end
        end
        return bIsType
    end
    
    --构造函数参数的传递，只支持一层, 出于动态语言的特性以及性能的考虑
    ClassDefine.new = function( self, ... )
    	local NewInstance = {}
    	NewInstance.__ClassDefine__ = self    -- IsType 函数的支持由此来
    
        NewInstance.IsClass = function( self, classtype )
            return self.__ClassDefine__:IsClass(classtype)
        end
        
        -- 这里要放到调用构造函数之前，因为构造函数里面，可能调用基类的成员函数或者成员变量
        setmetatable( NewInstance, InstanceMt )

        --先执行父函数
        for _i,bClass in ipairs(self.__tbl_Baseclass__) do
            for _j,bbClass in ipairs(bClass.__tbl_Baseclass__) do
                local funcCtor = rawget(bbClass, "Ctor")
                if funcCtor then
                    funcCtor(NewInstance,...)
                end
            end
            local funcCtor = rawget(bClass, "Ctor") 
            if funcCtor then
                funcCtor(NewInstance, ...)
            end
        end
        local funcCtor = rawget(self, "Ctor")
    	if funcCtor then
    	    funcCtor(NewInstance, ...)
    	end
    	
    	return NewInstance
    end

    setmetatable( ClassDefine, ClassDefineMt )
    return ClassDefine
end
