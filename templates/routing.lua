#!/usr/bin/env lua
-- -*- lua -*-
-- author : KDr2
--

local router = require('mch.router')
router.setup()

--
map('^/mchconsole',                 'mch.console.start')
--

-- TEST
map('^/hello%?name=(.*)',           'test.hello')
map('^/ltp',                        'test.ltp')

