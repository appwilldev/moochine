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
require 'mch.util'


function route_sorter(luri, ruri)
    if #luri==#ruri then
        return luri < ruri
    else
        return #luri > #ruri
    end
end

function map(route_table, route_order, uri, func_name)
    local mod,fn = string.match(func_name,'^(.+)%.([^.]+)$')
    mod=require(mod)
    route_table[uri]=mod[fn]
    table.insert(route_order,uri)
    -- table.sort(route_order,route_sorter) -- sort when merge!
end


function setup()
    local app_name=getfenv(2).__CURRENT_APP_NAME__
    if not mch.vars.get(app_name,"ROUTE_INFO") then
        mch.vars.set(app_name,"ROUTE_INFO",{})
    end
    if not mch.vars.get(app_name,"ROUTE_INFO")['ROUTE_MAP'] then
        mch.vars.get(app_name,"ROUTE_INFO")['ROUTE_MAP']={}
        mch.vars.get(app_name,"ROUTE_INFO")['ROUTE_ORDER']={}
    end
    mch.vars.get(app_name, "ROUTE_INFO").__logger = getfenv(2).__LOGGER -- TODO remove this line
    mch.vars.get(app_name, "ROUTE_INFO").logger = getfenv(2).__LOGGER
    mch.vars.get(app_name, "ROUTE_INFO")['map'] = mch.functional.curry(
        map,
        mch.vars.get(app_name,"ROUTE_INFO")['ROUTE_MAP'],
        mch.vars.get(app_name,"ROUTE_INFO")['ROUTE_ORDER']
    )
        
    mch.vars.get(app_name,"ROUTE_INFO")['get_config'] = mch.functional.curry(
        mch.util.get_config,
        app_name
    )
    setfenv(2, mch.vars.get(app_name,"ROUTE_INFO"))
end

function merge_routings(main_app, subapps)
    local main_routings=mch.vars.get(main_app,"ROUTE_INFO")['ROUTE_MAP']
    local main_routings_order=mch.vars.get(main_app,"ROUTE_INFO")['ROUTE_ORDER']
    for k,_ in pairs(subapps) do
        local sub_routings=mch.vars.get(k,"ROUTE_INFO")['ROUTE_MAP']
        for sk,sv in pairs(sub_routings) do main_routings[sk]=sv end
        local sub_routings_order=mch.vars.get(k,"ROUTE_INFO")['ROUTE_ORDER']
        for _,sv in ipairs(sub_routings_order) do table.insert(main_routings_order,sv) end
    end
    table.sort(main_routings_order, route_sorter)
end

