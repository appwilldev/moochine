#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module("test_v2",package.seeall)

local JSON = require("cjson")
require("mch.controller")

--[[
  Controller : ctller_v2
--]]

ctller_v2=mch.controller.Controller:new()

function ctller_v2:before(req, resp)
    resp:writeln("BEFORE FILTER")
end

function ctller_v2:get(req, resp, name)
    -- resp:writeln('Host: ' .. req.host)
    -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
    -- resp:writeln('name, ' .. req.args['name'])
    resp.headers['Content-Type'] = 'application/json'
    resp:write(JSON.encode(req.uri_args)) 
end


function ctller_v2:post(req, resp, name)
    -- resp:writeln('POST to Host: ' .. req.host)
    req:read_body()
    resp.headers['Content-Type'] = 'application/json'
    resp:writeln(JSON.encode(req.post_args))
end


--[[
  Controller : ctller_ltpv2
--]]

ctller_ltpv2=mch.controller.Controller:new()

function ctller_ltpv2:get(req,resp,...)
    resp:ltp('ltp.html',{v=123})
end

function ctller_ltpv2:after(req,resp)
    resp:writeln('AFTER ltp.html')
end


