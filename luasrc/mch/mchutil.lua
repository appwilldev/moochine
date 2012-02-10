#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('mchutil',package.seeall)

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
    require("mch.request")
    require("mch.response")
    global['MOOCHINE_MODULES']={}
    global['MOOCHINE_MODULES']['request']=request
    global['MOOCHINE_MODULES']['response']=response
end




