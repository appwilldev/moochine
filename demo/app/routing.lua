#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


mch_router=require 'mch.router'
mch_router.setup('demo')

-----------------------------------------------
-- 1.simple function mapping
map('^/1/hello%?name=(.*)',"test.hello")
map('^/1/ltp$',"test.ltp")


-- 2.mch controller mapping
map('^/1/hello_v2%?name=(.*)',"test_v2.ctller_v2")
map('^/1/ltp_v2',"test_v2.ctller_ltpv2")

-----------------------------------------------



