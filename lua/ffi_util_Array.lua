local ffi = require("ffi")
local ffi_util_func = require("ffi_util_func")

---
---@class ffi_util.Array<T>
---@field private m_type any
---@field private m_h ffi.cdata*
---@field private m_size integer
---@field private m_low integer
local Array = {}

---@private
Array.__index = Array

---Constructor.
---@generic T
---@param list T[]
---@param low? integer
---@return ffi_util.Array
function Array:new(list, low)
  local size = #list
  local handle = ffi.new(ffi.typeof(ffi_util_func.get_ffi_type(self.m_type) .. "[?]"), size)
  for i = 1, size do
    handle[i - 1] = ffi_util_func.get_ffi_data(list[i])
  end
  return self:take(handle, size, { low = low })
end

---
---@private
---@param handle ffi.cdata*?
---@param size integer
---@param options? {low:integer?,free:function?}
---@return ffi_util.Array
function Array:take(handle, size, options)
  options = options or { low = 1 }
  if handle and options.free then
    handle = ffi.gc(handle, options.free)
  end
  local arr = {
    m_h = handle,
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
  return self.m_h
end

---
---@generic T
---@param index integer
---@return T
function Array:value(index)
  if index < self:lower() or index > self:upper() then
    error("Out of range")
  end
  if type(self.m_type) == "table" then
    return self.m_type.take(self.m_h[index - self.m_low])
  else
    return self.m_h[index - self.m_low]
  end
end

---
---@param type_ table|string
function Array.instantiate(type_)
  local arr = { m_type = type_ }
  setmetatable(arr, Array)
  arr.__index = arr
  return arr
end

return Array
