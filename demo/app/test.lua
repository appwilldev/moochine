#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module("test",package.seeall)

function hello(name)
   ngx.say('Hello, ' .. name)
end

   