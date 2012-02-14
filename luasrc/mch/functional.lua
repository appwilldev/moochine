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




