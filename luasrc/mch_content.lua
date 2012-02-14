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



function setup_app()
    local app_path = ngx.var.MOOCHINE_APP
    local mch_home = ngx.var.MOOCHINE_HOME
    package.path = mch_home .. '/luasrc/?.lua;' .. package.path
    local mchutil=require("mch.util")
    mchutil.setup_app_env(mch_home,app_path,_G)
    require("routing")
end

function content()
    if not _G['MOOCHINE_APP'] then
        setup_app()
    end
    if not _G['MOOCHINE_APP'] then
        ngx.say('Can not setup MOOCHINE APP')
        ngx.exit(501)
    end
    local uri=ngx.var.REQUEST_URI
    local app_env_key='MOOCHINE_APP_' .. _G['MOOCHINE_APP']
    local route_map=_G[app_env_key]['route_map']
    for k,v in pairs(route_map) do
        local args=string.match(uri, k)
        if args then
            local request=_G['MOOCHINE_MODULES']['request']
            local response=_G['MOOCHINE_MODULES']['response']
            v(request.Request:new(),response.Response:new(),args)
            break
        end
    end
end

content()


