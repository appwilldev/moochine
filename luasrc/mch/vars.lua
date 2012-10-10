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


module('mch.vars', package.seeall)

require 'mch.functional'

function _setup()
    local mch_global={}
    
    local function _set(app_name,k,v)
        if not mch_global[app_name] then
            mch_global[app_name]={}
        end
        mch_global[app_name][k]=v
        return v
    end
    
    local function _get(app_name, k)
        if not mch_global[app_name] then
            mch_global[app_name]={}
        end
        return mch_global[app_name][k]
    end

    local function _vars(app_name)
        if not mch_global[app_name] then
            mch_global[app_name]={}
        end
        return mch_global[app_name]
    end
   
    return _set, _get, _vars
end

set, get, vars = _setup()


function make_table_perapp(tbl)
    if type(tbl) ~= "table" then return end
    
    local function _perapp_data(t)
        local data = rawget(t, ngx.ctx.MOOCHINE_APP_NAME)
        if not data then
            data = {}
            rawset(t, ngx.ctx.MOOCHINE_APP_NAME, data)
        end
        return data
    end
            
    local function _get(t, k)
        local data = _perapp_data(t)
        if k == "__table" then return data end
        return data[k]
    end

    local function _set(t, k, v)
        local data = _perapp_data(t)
        data[k]=v
    end

    setmetatable(tbl, {__index = _get, __newindex = _set})
end

function clear_table_perapp(tbl)
    if type(tbl) ~= "table" then return end
    rawset(tbl, ngx.ctx.MOOCHINE_APP_NAME, {})
end

function apairs(tbl)
    if type(tbl) ~= "table" then return end
    if tbl.__table then return pairs(tbl.__table) end
    return pairs(tbl)
end
