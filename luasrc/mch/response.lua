#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('response',package.seeall)

Response={}

function Response:new()
    local ret={
        headers=ngx.header
    }
    setmetatable(ret,self)
    self.__index=self
    return ret
end

function Response:write(content)
    ngx.print(content)
end

function Response:writeln(content)
    ngx.say(content)
end

function Response:redirect(url, status)
    ngx.redirect(url, status)
end

