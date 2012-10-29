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

local string_match = string.match

mch_vars = nil
mch_debug = nil

function is_inited(app_name, init)
    -- get/set the inited flag for app_name
    local r_G = _G
    local mt = getmetatable(_G)
    if mt then
        r_G = rawget(mt, "__index")
    end
    if not r_G['moochine_inited'] then
        r_G['moochine_inited'] = {}
    end
    if init == nil then
        return r_G['moochine_inited'][app_name]
    else
        r_G['moochine_inited'][app_name] = init
        if init then
            -- put logger into _G
            local logger = require("mch.logger")
            r_G["logger"] = logger.logger()
        end
    end
end

function setup_app()
    local mch_home = ngx.var.MOOCHINE_HOME or os.getenv("MOOCHINE_HOME")
    local app_name = ngx.var.MOOCHINE_APP_NAME
    local app_path = ngx.var.MOOCHINE_APP_PATH
    local app_config = app_path .. "/application.lua"

    package.path = mch_home .. '/luasrc/?.lua;' .. package.path
    mch_vars = require("mch.vars")
    mch_debug = require("mch.debug")
    local mchutil = require("mch.util")
    -- setup vars and add to package.path
    mchutil.setup_app_env(mch_home, app_name, app_path,
                          mch_vars.vars(app_name))

    local logger = require("mch.logger")
        
    local config = mchutil.loadvars(app_config)
    if not config then config={} end
    mch_vars.set(app_name,"APP_CONFIG",config)
    
    is_inited(app_name, true)
    
    if type(config.subapps) == "table" then
        for k, t in pairs(config.subapps) do
            local subpath = t.path
            package.path = subpath .. '/app/?.lua;' .. package.path
            local env = setmetatable({__CURRENT_APP_NAME__ = k,
                                      __MAIN_APP_NAME__ = app_name,
                                      __LOGGER = logger.logger()},
                                     {__index = _G})
            setfenv(assert(loadfile(subpath .. "/routing.lua")), env)()
        end
    end

    -- load the main-app's routing
    local env = setmetatable({__CURRENT_APP_NAME__ = app_name,
                              __MAIN_APP_NAME__ = app_name,
                              __LOGGER = logger.logger()},
                             {__index = _G})
    setfenv(assert(loadfile(app_path .. "/routing.lua")), env)()
    
    -- merge routings
    mchrouter = require("mch.router")
    mchrouter.merge_routings(app_name, config.subapps or {})

    if config.debug and config.debug.on and mch_debug then
        debug.sethook(mch_debug.debug_hook, "cr")
    end

end

function content()
    local ngx_ctx = ngx.ctx
    ngx_ctx.MOOCHINE_APP_NAME = ngx.var.MOOCHINE_APP_NAME
    if (not is_inited(ngx_ctx.MOOCHINE_APP_NAME)) or (not package.loaded["mch.vars"]) then
        local ok, ret = pcall(setup_app)
        if not ok then
            ngx.status = 500
            ngx.say("APP SETUP ERROR: " .. ret)
            return
        end
    else
        mch_vars  = require("mch.vars")
        mch_debug = require("mch.debug")
    end
    
    if not is_inited(ngx_ctx.MOOCHINE_APP_NAME) then
        ngx.status = 501
        ngx.say('Can not setup MOOCHINE APP ' .. ngx_ctx.MOOCHINE_APP_NAME)
        return
    end
    local uri = ngx.var.REQUEST_URI
    local route_map   = mch_vars.get(ngx_ctx.MOOCHINE_APP_NAME,"ROUTE_INFO")['ROUTE_MAP']
    local route_order = mch_vars.get(ngx_ctx.MOOCHINE_APP_NAME,"ROUTE_INFO")['ROUTE_ORDER']
    local page_found  = false
    -- match order by definition order
    for _, k in ipairs(route_order) do
        local args = string_match(uri, k)
        if args then
            page_found = true
            local v = route_map[k]
            local request  = mch_vars.get(ngx_ctx.MOOCHINE_APP_NAME,'MOOCHINE_MODULES')['request']
            local response = mch_vars.get(ngx_ctx.MOOCHINE_APP_NAME,'MOOCHINE_MODULES')['response']

            local requ = request.Request:new()
            local resp = response.Response:new()
            ngx_ctx.request  = requ
            ngx_ctx.response = resp
            
            if type(v) == "function" then                
                if mch_debug then mch_debug.debug_clear() end
                local ok, ret = pcall(v, requ, resp, args)
                if not ok then resp:error(ret) end
                resp:finish()
                resp:do_defers()
                resp:do_last_func()
            elseif type(v) == "table" then
                v:_handler(requ, resp, args)
            else
                ngx.exit(500)
            end
            break
        end
    end
    if not page_found then
        ngx.exit(404)
    end
end

----------
content()
----------

