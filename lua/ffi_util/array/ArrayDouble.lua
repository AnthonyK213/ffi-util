local Array = require("ffi_util.array.Array")

---@class ffi_util.array.ArrayDouble : ffi_util.array.Array<number>
---@field new fun(self:ffi_util.array.ArrayDouble,list:number[],low?:integer):ffi_util.array.ArrayDouble
---@field value fun(self:ffi_util.array.ArrayDouble,index:integer):number
---@field set_value fun(self:ffi_util.array.ArrayDouble,index:integer,value:number)
local ArrayDouble = Array.instantiate("double")

return ArrayDouble
