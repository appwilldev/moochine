#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


require 'mch.router'
router.setup('demo')

-----------------------------------------------

map('^/hello%?name=(.*)',"test.hello")

-----------------------------------------------



