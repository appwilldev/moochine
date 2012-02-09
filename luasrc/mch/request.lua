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
        uri_args=ngx.req.get_uri_args()
    }

    setmetatable(ret,self)
    self.__index=self
    return ret
end

function Request:read_body()
    ngx.req.read_body()
    self['post_args']=ngx.req.get_post_args()
end

