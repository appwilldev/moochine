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

module('mch.controller',package.seeall)

local mchdebug=require("mch.debug")

function default_handler(request,response,...)
    ngx.exit(403)
end

function dummy_filter()
    -- do nothing
    return true
end

Controller={}


function Controller:new()
    local o={}
    setmetatable(o,self)
    self.__index=self
    return o
end

function Controller:extend()
    local new_controler=self:new()
    return new_controller
end


-- FILTER
function Controller:before()
    -- do nothing
    return true
end


-- FILTER
function Controller:after()
    -- do nothing
    return true
end

--[[
  List of HTTP methods:

  * RFC 2616:
      OPTIONS,GET,HEAD,POST,PUT,DELETE,TRACE,CONNECT
  * RFC 2518
      PROPFIND,PROPPATCH,MKCOL,COPY,MOVE,LOCK,UNLOCK
  * RFC 3253
      VERSION-CONTROL,REPORT,CHECKOUT,CHECKIN,UNCHECKOUT,MKWORKSPACE,
      UPDATE,LABEL,MERGE,BASELINE-CONTROL,MKACTIVITY
  * RFC 3648
      ORDERPATCH
  * RFC 3744
      ACL
  * draft-dusseault-http-patch
      PATCH
  * draft-reschke-webdav-search
      SEARCH
--]]


-- HTTP GET
function Controller:get(request,response,...)
    default_handler(request,response,...)
    self.finished=true
end

-- HTTP POST
function Controller:post(request,response,...)
    default_handler(request,response,...)
    self.finished=true
end


-- HTTP PUT
function Controller:put(request,response,...)
    default_handler(request,response,...)
    self.finished=true
end


-- HTTP DELETE
function Controller:delete(request,response,...)
    default_handler(request,response,...)
    self.finished=true
end

-- HTTP Other Methods
function Controller:dummy_handler(request,response,...)
    default_handler(request,response,...)
    self.finished=true
end



-- Handle the Resuqt:
function Controller:_handler(request,response,...)
    local method=string.lower(ngx.var.request_method)
    local ctller=self:new()
    local handler=ctller[method] or ctller['dummy_handler']
    local args={...}
    mchdebug.debug_clear()
    local ok, ret=pcall(
        function()
            for i=1,1 do
                if type(handler)=="function" then
                    ctller:before(request,response)
                    if ctller.finished==true then break end
                    handler(ctller,request,response,unpack(args))
                    if ctller.finished==true then break end
                    ctller:after(request,response)
                end
            end
        end)
    if not ok then response:error(ret) end
    response:finish()
    response:do_defers()
end




