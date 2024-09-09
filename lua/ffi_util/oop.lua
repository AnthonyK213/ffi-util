local ffi = require("ffi")

local oop = {}

---Define a wrapper class for ffi cdata.
---@generic T
---@param ffi_type string
---@param options? {ctor:(fun(o:T,...):T),dtor:(fun(h:ffi.cdata*))}
---@return table
function oop.def_class(ffi_type, options)
  options = options or {}
  local class = {}
  class.__index = class
  class.__metatable = false
  setmetatable(class, {
    __index = {
      m_type = ffi_type,
      m_dtor = options.dtor,
    },
    __call = options.ctor or function(o)
      local handle = ffi.new(oop.get_type(o))
      return oop.take(o, handle, type(o.m_dtor) == "function")
    end,
    __metatable = false,
  })
  return class
end

---Define a default constructor from an initialization table.
---@param init_table table
---@return function
function oop.def_ctor(init_table)
  return function(o)
    local handle = ffi.new(oop.get_type(o), init_table)
    return oop.take(o, handle, type(o.m_dtor) == "function")
  end
end

---
---@param data ffi.cdata*
---@param field string
---@param Tp_? any
---@return any
function oop.get_field(data, field, Tp_)
  if type(Tp_) == "table" then
    return oop.take(Tp_, data[field])
  elseif type(Tp_) == "string" then
    return ffi.string(data[field])
  else
    return data[field]
  end
end

---
---@param data ffi.cdata*
---@param field string
---@param value any
function oop.set_field(data, field, value)
  data[field] = oop.get_data(value)
end

---
---@param Tp_ any
---@param handle ffi.cdata*
---@param is_owner? boolean
---@return any
function oop.take(Tp_, handle, is_owner)
  if handle and is_owner then
    local dtor = oop.get_dtor(Tp_)
    if dtor then
      handle = ffi.gc(handle, dtor)
    end
  end
  local o = { m_data = handle }
  setmetatable(o, Tp_)
  return o
end

---
---@param object any
---@return ffi.cdata*
function oop.get_type(object)
  if type(object) == "table" then
    return object.m_type
  elseif type(object) == "string" then
    return object
  else
    error("Unknown ffi type")
  end
end

---
---@param object any
---@return any
function oop.get_data(object)
  if type(object) == "table" then
    return object.m_data
  elseif type(object) == "string" then
    local result = ffi.new("char[?]", #object + 1)
    ffi.copy(result, object)
    return result
  else
    return object
  end
end

---
---@param object any
---@return fun(handle:ffi.cdata*)|nil
function oop.get_dtor(object)
  if type(object) == "table" then
    return object.m_dtor
  else
    return nil
  end
end

---@generic T
---@param tbl T
---@return T
function oop.make_readonly(tbl)
  return setmetatable({}, {
    __index = tbl,
    __newindex = function(o, k, v)
      error("Attempt to modify read-only structure!")
    end,
    __metatable = false,
  })
end

return oop.make_readonly(oop)
