local ffi = require("ffi")
local oop = require("ffi_util.oop")
local util = require("ffi_util.util")

---
---@class ffi_util.array.Array<T>
---@field private m_type any
---@field private m_data ffi.cdata*
---@field private m_size integer
---@field private m_low integer
local Array = {}

---@private
Array.__index = Array
Array.__metatable = false

---Constructor.
---@generic T
---@param list T[]|ffi_util.array.Array<T>
---@param low? integer
---@return ffi_util.array.Array<T>
function Array:new(list, low)
  local size, handle

  if util.is_array1(list) then
    size = #list
    handle = ffi.new(ffi.typeof(oop.get_type(self.m_type) .. "[?]"), size)
    for i = 1, size do
      handle[i - 1] = oop.get_data(list[i])
    end
  elseif list.m_type == self.m_type then
    ---@cast list ffi_util.array.Array
    size = list:size()
    handle = list:data()
  else
    size = 0
    handle = nil
  end

  return self:take(handle, size, { low = low })
end

---
---@private
---@param handle ffi.cdata*?
---@param size integer
---@param options? {low:integer?,free:function?}
---@return ffi_util.array.Array
function Array:take(handle, size, options)
  options = options or { low = 1 }
  if handle and options.free then
    handle = ffi.gc(handle, options.free)
  end
  local arr = {
    m_data = handle,
    m_size = size,
    m_low = options.low or 1,
  }
  setmetatable(arr, self)
  return arr
end

---
---@return integer
function Array:size()
  return self.m_size
end

---
---@return integer
function Array:lower()
  return self.m_low
end

---
---@return integer
function Array:upper()
  return self.m_low + self.m_size - 1
end

---
---@return ffi.cdata*
function Array:data()
  return self.m_data
end

---
---@private
---@param index integer
function Array:check_index(index)
  if index < self:lower() or index > self:upper() then
    error("Out of range")
  end
end

---
---@generic T
---@param index integer
---@return T
function Array:value(index)
  self:check_index(index)
  if type(self.m_type) == "table" then
    return oop.take(self.m_type, self.m_data[index - self.m_low])
  else
    return self.m_data[index - self.m_low]
  end
end

---
---@generic T
---@param index integer
---@param value T
function Array:set_value(index, value)
  self:check_index(index)
  self.m_data[index - self.m_low] = oop.get_data(value)
end

---
---@generic T
---@param type_ T
---@return ffi_util.array.Array<T>
function Array.instantiate(type_)
  local arr = { m_type = type_ }
  setmetatable(arr, Array)
  arr.__index = arr
  arr.__metatable = false
  return arr
end

return Array
