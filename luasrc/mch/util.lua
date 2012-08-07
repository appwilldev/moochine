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


module('mch.util',package.seeall)

local mchvars=require("mch.vars")

function read_all(filename)
    local file = io.open(filename, "r")
    local data = ((file and file:read("*a")) or nil)
    if file then
        file:close()
    end
    return data
end


function setup_app_env(mch_home, app_name, app_path, global)
    global['MOOCHINE_HOME']=mch_home
    global['MOOCHINE_APP']=appname
    global['MOOCHINE_APP_PATH']=app_path
    package.path = mch_home .. '/lualibs/?.lua;' .. package.path
    package.path = app_path .. '/app/?.lua;' .. package.path
    local request=require("mch.request")
    local response=require("mch.response")
    global['MOOCHINE_MODULES']={}
    global['MOOCHINE_MODULES']['request']=request
    global['MOOCHINE_MODULES']['response']=response
end


function loadvars(file)
    local env = setmetatable({}, {__index=_G})
    assert(pcall(setfenv(assert(loadfile(file)), env)))
    setmetatable(env, nil)
    return env
end

function get_config(appname, key)
    
    if key==nil then
        key=appname
        appname=ngx.var.MOOCHINE_APP_NAME
    end
    if appname == ngx.var.MOOCHINE_APP_NAME then
        local ret=ngx.var[key]
        if ret then return ret end
        local app_conf=mchvars.get(ngx.var.MOOCHINE_APP_NAME,"APP_CONFIG")
        return app_conf[key]
    end
    
    local subapps=mchvars.get(ngx.var.MOOCHINE_APP_NAME,"APP_CONFIG").subapps or {}
    local subconfig=subapps[appname].config or {}
    return subconfig[key]
    
end

function _strify(o, tab, act, logged)
    local v = tostring(o)
    if logged[o] then return v end
    if string.sub(v,0,6) == "table:" then
        logged[o] = true
        act = "\n" .. string.rep("|    ",tab) .. "{ [".. tostring(o) .. ", "
        act = act .. table_real_length(o) .." item(s)]"
        for k, v in pairs(o) do
            act = act .."\n" .. string.rep("|    ", tab)
            act = act .. "|   *".. k .. "\t=>\t" .. _strify(v, tab+1, act, logged)
        end
        act = act .. "\n" .. string.rep("|    ",tab) .. "}"
        return act
    else
        return v
    end
end

function strify(o) return _strify(o, 1, "", {}) end

function table_print(t)
    local s1="\n* Table String:"
    local s2="\n* End Table"
    return s1 .. strify(t) .. s2
end

function table_real_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end
