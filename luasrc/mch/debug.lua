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
    local debug_info={info=""}
    
    function _debug_hook(event, extra)
        local info = debug.getinfo(2)
        if info.currentline<=0 then return end
        if (string.find(info.short_src,"moochine/luasrc") or 
        string.find(info.short_src,"moochine/lualib")) then
            return
        end
        local sinfo=(string.format("%s function %s in file [%s]:%d,<br/>\r\n",
                                   event,
                                   info.name,
                                   info.short_src,
                                   info.currentline))
        debug_info.info = debug_info.info .. sinfo
    end

    function _debug_clear()
        debug_info.info="<br/><H4>DEBUG INFO:</H4>"
    end

    function _debug_info()
        return debug_info
    end
    
    return _debug_hook, _debug_clear, _debug_info
end


debug_hook, debug_clear, debug_info = debug_utils()


