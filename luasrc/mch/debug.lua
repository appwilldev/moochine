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

module('mch.debug',package.seeall)

local mchutil=require('mch.util')
local front=require('mch.front')
local mchvars=require('mch.vars')
local functional=require('mch.functional')

function traceback ()
    for level = 1, math.huge do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        if info.what == "C" then   -- is a C function?
            print(level, "C function")
        else   -- a Lua function
            print(string.format("[%s]:%d", info.short_src,
                                info.currentline))
        end
    end
end

function debug_utils()
    local debug_info={info={}}
    
    function _debug_hook(event, extra)
        local info = debug.getinfo(2)
        if info.currentline<=0 then return end
        --if (string.find(info.short_src,"moochine/luasrc") or 
        --string.find(info.short_src,"moochine/lualib")) then
        --return
        --end
        info.event=event
        table.insert(debug_info.info,info)
    end

    function _debug_clear()
        debug_info.info={} 
    end

    function _debug_info()
        return debug_info
    end
    
    return _debug_hook, _debug_clear, _debug_info
end


debug_hook, debug_clear, debug_info = debug_utils()


function debug_info2html()
    
    local ret = front.DEBUG_INFO_CSS .. [==[
                <div id="moochine-table-of-contents">
                <h2>DEBUG INFO </h2>
                <div id="moochine-text-table-of-contents"><ul>
        ]==]
    for _, info in ipairs(debug_info().info) do
        local estr= "unkown event"
        if info.event=="call" then
            estr = " -> "
        elseif info.event=="return" then
            estr = " <- "
        end
        local sinfo=(string.format("<li>%s [function %s] in file [%s]:%d,</li>\r\n",
                                   estr,
                                   tostring(info.name),
                                   info.short_src,
                                   info.currentline))
        ret = ret .. sinfo
    end
    return ret .. "</ul></div></div>"
end


function debug_info2text()
    local ret ="DEBUG INFO:\n"
    for _, info in ipairs(debug_info().info) do
        local estr= "unkown event"
        if info.event=="call" then
            estr = " -> "
        elseif info.event=="return" then
            estr = " <- "
        end
        local sinfo=(string.format("%s [function %s] in file [%s]:%d,\n",
                                   estr,
                                   tostring(info.name),
                                   info.short_src,
                                   info.currentline))
        ret = ret .. sinfo
    end
    return ret
end



