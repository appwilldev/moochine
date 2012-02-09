#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('response',package.seeall)

Response={}

function Response:new()
   local ret={}
   ret['headers']=ngx.header
   setmetatable(ret,self)
   self.__index=self
   return ret
end


function Response:headers()
   return ngx.header
end

function Response:set_header(key,value)
   ngx.header[key]=value
end

function Response:write(content)
   ngx.print(content)
end





