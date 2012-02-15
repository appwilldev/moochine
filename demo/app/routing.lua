#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


require 'mch.router'
mch.router.setup('demo')

-----------------------------------------------
-- 1.simple function mapping
map('^/hello%?name=(.*)',"test.hello")
map('^/ltp$',"test.ltp")


-- 2.mch controller mapping
map('^/hello_v2%?name=(.*)',"test_v2.ctller_v2")
map('^/ltp_v2',"test_v2.ctller_ltpv2")

-----------------------------------------------



