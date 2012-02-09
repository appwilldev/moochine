#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


function setup_app()
   local app_path = ngx.var.MOOCHINE_APP
   local mch_home = ngx.var.MOOCHINE_HOME
   _G['MOOCHINE_APP']=string.match(app_path,'^.*/([^/]+)/?$')
   package.path = mch_home .. '/luasrc/?.lua;' .. package.path
   package.path = app_path .. '/app/?.lua;' .. package.path
   require("mch.request")
   require("mch.response")
   require("routing")
end

function content()
   if not _G['MOOCHINE_APP'] then
      setup_app()
   end
   if not _G['MOOCHINE_APP'] then
      ngx.say('Can not setup MOOCHINE APP')
      ngx.exit(501)
   end
   local uri=ngx.var.REQUEST_URI
   local app_env_key='MOOCHINE_APP_' .. _G['MOOCHINE_APP']
   local route_map=_G[app_env_key]['route_map']
   for k,v in pairs(route_map) do
      local args=string.match(uri, k)
      if args then
         v(request.Request:new(),response.Response:new(),args)
         break
      end
   end
end

content()


