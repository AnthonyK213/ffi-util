local ffi_util = {}

ffi_util._VERSION = "ffi_util.lua 1.0.0"
ffi_util._URL = "https://github.com/AnthonyK213/ffi-util"

ffi_util.array = require("ffi_util.array")
ffi_util.oop   = require("ffi_util.oop")
ffi_util.util  = require("ffi_util.util")

return ffi_util.oop.make_readonly(ffi_util)
