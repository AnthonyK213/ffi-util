local array = {}

array.Array = require("ffi_util.array.Array")
array.ArrayDouble = require("ffi_util.array.ArrayDouble")
array.ArrayInt32 = require("ffi_util.array.ArrayInt32")

return require("ffi_util.oop").make_readonly(array)
