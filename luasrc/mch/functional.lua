#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module('mch.functional',package.seeall)

function _curry(func, arg)
    local curry_args= arg
    function inner(...)
        return func(curry_args,...)
    end
    return inner
end



function curry(func, ...)
    local inner=func
    for i=1,select("#", ...) do
        argi=select(i, ...)
        inner=_curry(inner,argi)
    end
    return inner
end




