#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('request',package.seeall)

Request={}

function Request:new()
   local ret={}
   ret['method']=ngx.var.request_method
   ret['schema']=ngx.var.schema
   ret['host']=ngx.var.host
   ret['hostname']=ngx.var.hostname
   ret['uri']=ngx.var.request_uri
   ret['path']=ngx.var.uri
   ret['filename']=ngx.var.request_filename
   ret['query_string']=ngx.var.query_string
   ret['args']=ngx.req.get_uri_args()
   ret['headers']=ngx.req.get_headers()
   ret['remote_addr']=ngx.var.remote_addr
   ret['remote_port']=ngx.var.remote_port
   ret['remote_user']=ngx.var.remote_user
   
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





