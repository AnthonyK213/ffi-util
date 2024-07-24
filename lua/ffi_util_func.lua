local ffi_util_func = {}

---
---@generic T
---@param array2 T[][]
---@return integer
---@return integer
---@return T[]
function ffi_util_func.flatten_array2(array2)
  if #array2 == 0 then
    return 0, 0, {}
  end

  local n_u = #array2
  local n_v = #(array2[1])

  local result = {}
  for i = 1, n_u, 1 do
    if #(array2[i]) ~= n_v then
      return 0, 0, {}
    end

    for j = 1, n_v, 1 do
      table.insert(result, array2[i][j])
    end
  end

  return n_u, n_v, result
end

---
---@param object any
---@return ffi.cdata*
function ffi_util_func.get_ffi_type(object)
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
function ffi_util_func.get_ffi_data(object)
  if type(object) == "table" then
    return object:data()
  else
    return object
  end
end

return ffi_util_func
