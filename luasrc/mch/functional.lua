#!/usr/bin/env lua
-- -*- lua -*-
-- Copyright 2012 Appwill Inc.
-- Author : KDr2
--
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--


module('mch.functional',package.seeall)

--[[
-- common functional tools
--]]


function curry(func, ...)
    if select("#", ...) == 0 then return func end
    local args={...}
    local function inner(...)
        local _args={...}
        local real_args={unpack(args)}
        for _,v in ipairs(_args) do table.insert(real_args,v) end
        return func(unpack(real_args))
    end
    return inner
end

function map(func,tab)
    local retv={}
    for k,v in pairs(tab) do
        local rk,rv=func(k,v)
        if rk then
            retv[rk]=rv
        else
            table.insert(retv,rv)
        end
    end
    return retv
end

function any(func,tab)
    for k,v in pairs(tab) do
        if func(k,v) then return true end
    end
    return false
end
    
function filter(func,tab)
    local retv={}
    for k,v in pairs(tab) do
        if func(k,v) then retv[k]=v end
    end
    return retv
end

function fold(func,acc,tab)
    local ret=acc
    for k,v in pairs(tab) do
        ret=func(ret,k,v)
    end
    return ret
end



--[[
-- common lua functions based on functional tools above
--]]

table_keys=curry(map,function(k,_)return nil,k end)
table_values=curry(map,function(_,v)return nil,v end)
table2array=table_values


