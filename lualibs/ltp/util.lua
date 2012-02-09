--
-- Copyright 2007-2008 Savarese Software Research Corporation.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.savarese.com/software/ApacheLicense-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local function slice(t, start, size)
  local sz = (size or (#t - start + 1))
  local result = { }

  for i = 1, sz, 1 do
    result[i] = t[start + i - 1]
  end

  return result
end

local function dual_index(index1, index2)
  local index1_type = type(index1)

  if index1_type == "table" then
    return function(t,k)
             if index1[k] ~= nil then
               return index1[k]
             else
               return index2[k]
             end
           end
  elseif index1_type == "function" then
    return function(t,k)
             local v = index1(t,k)
             if v ~= nil then
               return v
             else
               return index2[k]
             end
           end
  end
end

local function merge_index(t1, t2)
  local mt = getmetatable(t1)

  if mt ~= nil then
    if mt.__index ~= nil then
      mt.__index = dual_index(mt.__index, t2)
    else
      mt.__index = t2
    end
    return t1
  else
    return setmetatable(t1, {__index = t2})
  end
end

local function merge_table(t1, t2)
  local typet1

  for k, v in pairs(t2) do
    typet1 = type(t1[k])
    if t1[k] ~= v and type(v) == "table" then
      if typet1 == "table" then
        merge_table(t1[k], v)
      elseif typet1 == "nil" then
        t1[k] = v
      end
    end
  end

  return merge_index(t1, t2)
end

local function import(module_name, environment)
  return setfenv(package.loaders[2](module_name), environment)()
end

local function read_all(filename)
  local file = io.open(filename, "r")
  local data = ((file and file:read("*a")) or nil)
  if file then
    file:close()
  end
  return data
end

return { slice = slice,
         merge_index = merge_index,
         merge_table = merge_table,
         import = import,
         read_all = read_all }
