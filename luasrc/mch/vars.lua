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


module('mch.vars',package.seeall)

require 'mch.functional'

function _setup()
    local mch_global={}
    
    function _set(k,v)
        mch_global[k]=v
        return v
    end
    
    function _get(k)
        return mch_global[k]
    end

    function _vars(k)
        return mch_global
    end
   
    return _set,_get, _vars
end

set,get,vars=_setup()


