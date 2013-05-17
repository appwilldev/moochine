#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2013 Appwill Inc.
-- author : ldmiao
--

module("test", package.seeall)

local JSON = require("cjson")
local Redis = require("resty.redis")

function hello(req, resp, name)
    logger:i("hello request started!")
    resp.headers['Content-Type'] = 'application/json'

    if req.method=='GET' then
        resp:writeln(JSON.encode(req.uri_args))
    elseif req.method=='POST' then
        req:read_body()
        resp:writeln(JSON.encode(req.post_args))
    end
    logger:i("hello request completed!")
end

function ltp(req, resp)
    resp:ltp("ltp.html", {v="hello, moochine!"})
end

