#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('request',package.seeall)

Request={}

function Request:new()
   local ret={}
   ret['headers']=ngx.req.get_headers()
   setmetatable(ret,self)
   self.__index=self
   return ret
end


function Request:get_headers()
   return ngx.req.get_headers()
end

function Request:get_header(key)
   return ngx.req.get_headers()[key]
end





