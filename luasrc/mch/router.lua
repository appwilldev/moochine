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


module('mch.router',package.seeall)

require 'mch.functional'
require 'mch.vars'


function map(route_table, uri, func_name)
    local mod,fn = string.match(func_name,'^(.+)%.([^.]+)$')
    mod=require(mod)
    route_table[uri]=mod[fn]
end


function setup(app_name)
    app_name='MOOCHINE_APP_' .. app_name
    if not mch.vars.get(app_name) then
        mch.vars.set(app_name,{})
    end
    if not mch.vars.get(app_name)['route_map'] then
        local route_map={}
        mch.vars.get(app_name)['route_map']=route_map
    end
    mch.vars.get(app_name)['map']=mch.functional.curry(map,mch.vars.get(app_name)['route_map'])
    setfenv(2,mch.vars.get(app_name))
end


