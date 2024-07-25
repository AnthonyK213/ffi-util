local oop = {}

---
---@generic T
---@param ffi_type string
---@param ctor fun(o:T,...):T
---@return table
function oop.def_class(ffi_type, ctor)
  local class = {}
  class.__index = class
  class.m_type = ffi_type
  setmetatable(class, { __call = ctor })
  return class
end

---
---@param Tp_ any
function oop.def_ctor(Tp_)
  setmetatable(Tp_, {
    __call = function(o, ...) return o:new(...) end
  })
end

---
---@param data ffi.cdata*
---@param field string
---@param Tp_ table?
---@return any
function oop.get_field(data, field, Tp_)
  if type(Tp_) == "table" then
    return oop.take(Tp_, data[field])
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
---@return any
function oop.take(Tp_, handle)
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
  else
    return object
  end
end

return oop
