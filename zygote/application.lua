#!/usr/bin/env lua

debug = {
    on = false,
    to = "response", -- "ngx.log"
}

logger = {
    file  = "logs/moochine.log",
    level = "INFO",
}

config = {
    templates = 'templates',
}

subapps={
}

