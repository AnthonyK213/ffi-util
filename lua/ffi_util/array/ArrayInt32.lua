local Array = require("ffi_util.array.Array")

---@class ffi_util.array.ArrayInt32 : ffi_util.array.Array<integer>
---@field new fun(self:ffi_util.array.ArrayInt32,list:integer[]|ffi_util.array.ArrayInt32,low?:integer):ffi_util.array.ArrayInt32
---@field value fun(self:ffi_util.array.ArrayInt32,index:integer):integer
---@field set_value fun(self:ffi_util.array.ArrayInt32,index:integer,value:integer)
local ArrayInt32 = Array.instantiate("int")

return ArrayInt32
