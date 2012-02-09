#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

require 'mch.functional'

module('router',package.seeall)


function map(route_table, uri, func_name)
   local mod,fn = string.match(func_name,'^(.+)%.([^.]+)$')
   mod=require(mod)
   route_table[uri]=mod[fn]
end


function setup(app_name)
   app_name='MOOCHINE_APP_' .. app_name
   if not _G[app_name] then
      _G[app_name]={}
   end
   local route_map={}
   _G[app_name]['route_map']=route_map
   _G[app_name]['map']=functional.curry(map,route_map)
   setfenv(2,_G[app_name])
end


