#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module("test",package.seeall)

function hello(req,resp,name)
   resp:write('Agent: ' .. req:get_header('User-Agent'))
   resp:write('Agent: ' .. req.headers['User-Agent'])
   resp:write('Hello, ' .. name)
end

   