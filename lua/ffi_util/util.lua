local util = {}

---Test if `t` is a table indexed only by contiguous integers starting from 1.
---@param t table
---@return boolean
function util.is_array1(t)
  if type(t) ~= "table" then
    return false
  end

  if next(t) == nil then
    return getmetatable(t) == nil
  end

  local j = 1
  for _ in pairs(t) do
    if t[j] == nil then
      return false
    end
    j = j + 1
  end

  return true
end

---
---@generic T
---@param array2 T[][]
---@return integer
---@return integer
---@return T[]
function util.flatten_array2(array2)
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

return require("ffi_util.oop").make_readonly(util)
