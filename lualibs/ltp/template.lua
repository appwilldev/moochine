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

local ltp = require('ltp.util')

local function compile_template_to_table(result, data, start_lua, end_lua)
  local LF, CR, EQ = 10, 13, 61
  local i1, i2, i3

  i3 = 1

  repeat
    i2, i1 = data:find(start_lua, i3, true)

    if i2 then
      if i3 < i2 then
        table.insert(result, "table.insert(output,")
        table.insert(result, string.format('%q', data:sub(i3, i2 - 1)))
        table.insert(result, ");")
      end

      i1 = i1 + 2
      i2, i3 = data:find(end_lua, i1, true)

      if i2 then
        if data:byte(i1-1) == EQ then
          table.insert(result, "table.insert(output,")
          table.insert(result, data:sub(i1, i2 - 1))
          table.insert(result, ");")
          i3 = i3 + 1
        else
          table.insert(result, data:sub(i1, i2 - 1))
          i3 = i3 + 1
          if data:byte(i3) == LF then
            i3 = i3 + 1
          elseif data:byte(i3) == CR and data:byte(i3+1) == LF then
            i3 = i3 + 2
          end
        end
      end
    elseif i3 <= #data then
      table.insert(result, "table.insert(output,")
      table.insert(result, string.format('%q', data:sub(i3)))
      table.insert(result, ");")
    end
  until not i2

  return result
end

local function compile_template_as_function(data, start_lua, end_lua)
  local result = { "return function(output) " }
  table.insert(compile_template_to_table(result, data, start_lua, end_lua),
               "end")
  return table.concat(result)
end

local function compile_template_as_chunk(data, start_lua, end_lua)
  local result = { "local output = ... " }
  return
  table.concat(compile_template_to_table(result, data, start_lua, end_lua))
end

local function compile_template(data, start_lua, end_lua)
  return table.concat(compile_template_to_table({ }, data, start_lua, end_lua))
end

local function load_template(data, start_lua, end_lua)
  return assert(loadstring(compile_template_as_chunk(data, start_lua, end_lua),
                           "=(load)"))
end

local function execute_template(template, environment, output)
  setfenv(template, environment)(output)
end

local function basic_environment(merge_global, environment)
  if not environment then
    environment = { }
  end

  if merge_global then
    ltp.merge_index(environment, _G)
  else
    environment.table = table
  end

  return environment
end

local function load_environment(env_files, merge_global)
  local environment = nil

  if env_files and #env_files > 0 then
    for i = 1,#env_files,1 do
      local efun = assert(loadfile(env_files[i]))

      if i > 1 then
        environment = ltp.merge_table(setfenv(efun, environment)(), environment)
      else
        environment = basic_environment(merge_global, efun())
      end
    end
  else
    environment = basic_environment(merge_global)
  end

  return environment
end

local function read_template(template)
  return ((template == "-" and io.stdin:read("*a")) or ltp.read_all(template))
end

local function render_template(template_data, start_lua, end_lua, environment)
  local rfun = load_template(template_data, start_lua, end_lua)
  local output = { }
  execute_template(rfun, environment, output)
  return table.concat(output)
end

local function execute_env_code(env_code, environment)
  for i = 1,#env_code do
    local fun, emsg = loadstring(env_code[i])

    if fun then
      setfenv(fun, environment)()
    else
      error("error loading " .. env_code[i] .. "\n" .. emsg)
    end
  end
end

local function render(outfile, num_passes, template, merge_global,
                      env_files, start_lua, end_lua, env_code)
  local data = assert(read_template(template), "error reading " .. template)
  local environment = load_environment(env_files, merge_global)

  execute_env_code(env_code, environment)

  if num_passes > 0 then
    for i = 1,num_passes do
      data = render_template(data, start_lua, end_lua, environment)
    end
  else
    -- Prevent an infinite loop by capping expansion to 100 times.
    num_passes = 1
    repeat
      data = render_template(data, start_lua, end_lua, environment)
      num_passes = num_passes + 1
    until data:find(start_lua, 1, true) == nil or num_passes >= 100
  end

  outfile:write(data);
end

local function compile_as_function(outfile, template, start_lua, end_lua)
  local data = read_template(template)
  outfile:write(compile_template_as_function(data, start_lua, end_lua))
end

local function compile(outfile, template, start_lua, end_lua)
  local data = read_template(template)
  outfile:write(compile_template(data, start_lua, end_lua))
end

return ltp.merge_table(
  {
    compile_template_to_table    = compile_template_to_table,
    compile_template_as_chunk    = compile_template_as_chunk,
    compile_template_as_function = compile_template_as_function,
    compile_template             = compile_template,
    load_template                = load_template,
    execute_template             = execute_template,
    basic_environment            = basic_environment,
    load_environment             = load_environment,
    render_template              = render_template,
    execute_env_code             = execute_env_code,
    render                       = render,
    compile_as_function          = compile_as_function,
    compile                      = compile
  },
  ltp
)
