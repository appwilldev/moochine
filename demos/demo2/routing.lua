#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

local router=require('mch.router')
router.setup()

-----------------------------------------------
-- 1.simple function mapping
map('^/2/hello%?name=(.*)',"d2_test.hello")
map('^/2/ltp$',"d2_test.ltp")


-- 2.mch controller mapping
map('^/hello_v2%?name=(.*)',"d2_test_v2.ctller_v2")
map('^/ltp_v2',"d2_test_v2.ctller_ltpv2")

-----------------------------------------------



