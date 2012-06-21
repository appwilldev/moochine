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

mch_vars=nil

function is_inited()
    local o_G=rawget(getmetatable(_G),"__index")
    return o_G['moochine_inited']
end

function setup_app()
    local app_path = ngx.var.MOOCHINE_APP
    local mch_home = ngx.var.MOOCHINE_HOME
    local app_extra= ngx.var.MOOCHINE_APP_EXTRA
    package.path = mch_home .. '/luasrc/?.lua;' .. package.path
    mch_vars=require("mch.vars")
    local mchutil=require("mch.util")
    mchutil.setup_app_env(mch_home,app_path,mch_vars.vars())
    require("routing")
    if app_extra then
        mch_vars.set('MOOCHINE_EXTRA_APP_PATH',app_extra)
        package.path = app_extra .. '/app/?.lua;' .. package.path
        require("extra_routing")
    end

    local o_G=rawget(getmetatable(_G),"__index")
    o_G['moochine_inited']=true
    
end

function content()
    if not is_inited() then
        setup_app()
    else
        mch_vars=require("mch.vars")
    end
    
    if not is_inited() then
        ngx.say('Can not setup MOOCHINE APP')
        ngx.exit(501)
    end
    local uri=ngx.var.REQUEST_URI
    local app_env_key='MOOCHINE_APP_' .. mch_vars.get('MOOCHINE_APP')
    local route_map=mch_vars.get(app_env_key)['route_map']
    for k,v in pairs(route_map) do
        local args=string.match(uri, k)
        if args then
            local request=mch_vars.get('MOOCHINE_MODULES')['request']
            local response=mch_vars.get('MOOCHINE_MODULES')['response']
            if type(v)=="function" then
                local response=response.Response:new()
                v(request.Request:new(),response,args)
                ngx.print(response._output)
            elseif type(v)=="table" then
                v:_handler(request.Request:new(),response.Response:new(),args)
            else
                ngx.exit(500)
            end
            break
        end
    end
end

content()


