#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--

module('response',package.seeall)

require('mch.mchutil')

ltp=require("ltp.template")

Response={ltp=ltp}

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


function Response:ltp(template,data)
    local tdata=mchutil.read_all(MOOCHINE_APP_PATH .. "/templates/" .. template)
    local mt={}
    mt.__index=_G
    setmetatable(data,mt)
    local page=ltp.render_template(tdata,'<?lua','?>',data)
    ngx.say(page)
end


