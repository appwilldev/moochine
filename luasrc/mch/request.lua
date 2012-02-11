#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('request',package.seeall)

Request={}

function Request:new()
    local ret={
        method=ngx.var.request_method,
        schema=ngx.var.schema,
        host=ngx.var.host,
        hostname=ngx.var.hostname,
        uri=ngx.var.request_uri,
        path=ngx.var.uri,
        filename=ngx.var.request_filename,
        query_string=ngx.var.query_string,
        headers=ngx.req.get_headers(),
        remote_addr=ngx.var.remote_addr,
        remote_port=ngx.var.remote_port,
        remote_user=ngx.var.remote_user,
        content_type=ngx.var.content_type,
        content_length=ngx.var.content_length,
        uri_args=ngx.req.get_uri_args(),
        socket=ngx.req.socket
    }

    setmetatable(ret,self)
    self.__index=self
    return ret
end

function Request:read_body()
    ngx.req.read_body()
    self['post_args']=ngx.req.get_post_args()
end

function Request:get_cookie(key, decrypt)
    local value = ngx.var['cookie_'..key]

    if value and value~="" and decrypt==true then
        value=ndk.set_var.set_decode_base64(value)
        value=ndk.set_var.set_decrypt_session(value)
    end

    return value
end


-- to prevent use of casual module global variables
getmetatable(request).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '
            .. debug.traceback())
end
