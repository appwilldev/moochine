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

function read_all(filename)
    local file = io.open(filename, "r")
    local data = ((file and file:read("*a")) or nil)
    if file then
        file:close()
    end
    return data
end


function setup_app_env(mch_home,app_path,global)
    global['MOOCHINE_HOME']=mch_home
    global['MOOCHINE_APP']=string.match(app_path,'^.*/([^/]+)/?$')
    global['MOOCHINE_APP_PATH']=app_path
    package.path = mch_home .. '/lualibs/?.lua;' .. package.path
    package.path = app_path .. '/app/?.lua;' .. package.path
    local request=require("mch.request")
    local response=require("mch.response")
    global['MOOCHINE_MODULES']={}
    global['MOOCHINE_MODULES']['request']=request
    global['MOOCHINE_MODULES']['response']=response
end




