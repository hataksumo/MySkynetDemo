
local {name} = {

count = {count},
subformCount = 1,

subforms = {
    {
        path = "Config/Data/{name}/{name}_1",
        minID = {minID},
        maxID = {maxID},
   },

},

strFields = {
},

defaultValue = {

},
strValues = {
}

}
{name}.__index = {name}
setmetatable({name},GameDataBase.SheetBase)
return {name}