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

function Response:set_cookie(key, value, decrypt, duration, path)
    if not key or key=="" or not value then
        return
    end

    if not duration or duration<=0 then
        duration=86400
    end

    if not path or path=="" then
        path = "/"
    end

    if value and value~="" and decrypt==true then
        value=ndk.set_var.set_encrypt_session(value)
        value=ndk.set_var.set_encode_base64(value)
    end

    local expiretime=ngx.time()+duration
    expiretime = ngx.cookie_time(expiretime)
    ngx.header["Set-Cookie"]={
        table.concat({key, "=", value, "; expires=", expiretime, "; path=", path})
    }
end

--[[
LTP Template Support
--]]

ltp_templates_cache={}

function ltp_function(template)
    ret=ltp_templates_cache[template]
    if ret then return ret end
    local tdata=mchutil.read_all(MOOCHINE_APP_PATH .. "/templates/" .. template)
    local rfun = ltp.load_template(tdata, '<?lua','?>')
    ltp_templates_cache[template]=rfun
    return rfun
end

function Response:ltp(template,data)
    local rfun=ltp_function(template)
    local output = {}
    local mt={__index=_G}
    setmetatable(data,mt)
    ltp.execute_template(rfun, data, output)
    ngx.print(output)
end


