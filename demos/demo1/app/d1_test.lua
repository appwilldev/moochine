#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module("d1_test",package.seeall)

local JSON = require("cjson")
local mchutil = require("mch.util")

function hello(req, resp, name)
    if req.method=='GET' then
        -- resp:writeln('Host: ' .. req.host)
        -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
        -- resp:writeln('name, ' .. req.uri_args['name'])
        resp.headers['Content-Type'] = 'application/json'
        resp:write(JSON.encode(req.uri_args))
    elseif req.method=='POST' then
        -- resp:writeln('POST to Host: ' .. req.host)
        req:read_body()
        resp.headers['Content-Type'] = 'application/json'
        resp:writeln(JSON.encode(req.post_args))
    end 
end


function ltp(req,resp,...)
    -- resp:write(1+"a")
    local issub, name = mchutil.is_subapp()
    logger:debug("ltp")
    if issub then
        resp:writeln("subapp:" .. name)
    else
        resp:writeln("mainapp")
    end
    resp:ltp('d1_ltp.html',{v=111})
end


