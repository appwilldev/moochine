#!/usr/bin/env lua
-- -*- lua -*-
-- Copyright 2012 Appwill Inc.
-- Author : KDr2
--
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--

module("mch.logger", package.seeall)

logging = require("logging")
mchutil = require("mch.util")
mchvars = require("mch.vars")

function get_logger(appname)
    local logger = mchvars.get(appname, "__LOGGER")
    if logger then return logger end
    
    local filename = "/dev/stderr"
    local level = "DEBUG"
    -- local log_config = mchutil.get_config(appname, "logger")
    local log_config = mchutil.get_config("logger")
    
    if log_config and type(log_config.file) == "string" then
        filename = log_config.file
    end
    
    if log_config and type(log_config.level) == "string" then
        level = log_config.level
    end

    local f = io.open(filename, "a")
    if not f then
        return nil, string.format("file `%s' could not be opened for writing", filename)
    end
    f:setvbuf("line")

    local function log_appender(self, level, message)
        local date = os.date("%m-%d %H:%M:%S")
        local frame = debug.getinfo(4)
        local s = string.format('[%s] [%s] [%s:%d] %s\n',
                                date, level,
                                string.gsub(frame.short_src, '%.lua$', ''),
                                frame.currentline,
                                message)
        f:write(s)
        return true
    end
    
    logger = logging.new(log_appender)
    logger:setLevel(level)
    mchvars.set(appname, "__LOGGER", logger)
    logger._log = logger.log
    logger._setLevel = logger.setLevel

    logger.log = function(self, level, ...)
                     local _logger = get_logger(ngx.var.MOOCHINE_APP_NAME)
                     _logger._log(self, level, ...)
                 end
    logger.setLevel = function(self, level, ...)
                          local _logger = get_logger(ngx.var.MOOCHINE_APP_NAME)
                          _logger:_log("ERROR", "Can not setLevel")
                      end
    -- for _, l in ipairs(logging.LEVEL) do -- logging does not export this variable :(
    local levels = {d = "DEBUG", i = "INFO", w = "WARN", e = "ERROR", f = "FATAL"}
    for k, l in pairs(levels) do
        logger[k] = function(self, ...)
                        logger.log(self, l, ...)
                    end
        logger[string.lower(l)] = logger[k]
    end
    logger.tostring = logging.tostring
    logger.table_print = mchutil.table_print
    
    return logger
end

function logger()
    local logger = get_logger(ngx.var.MOOCHINE_APP_NAME)
    return logger
end

