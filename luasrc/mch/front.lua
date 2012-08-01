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

module('mch.front',package.seeall)

DEBUG_INFO_CSS=[==[
            <style rel="stylesheet" type="text/css">
            #moochine-table-of-contents {
                font-size: 9pt;
                position: fixed;
                right: 0em;
                top: 0em;
                background: white;
                -webkit-box-shadow: 0 0 1em #777777;
                -moz-box-shadow: 0 0 1em #777777;
                -webkit-border-bottom-left-radius: 5px;
                -moz-border-radius-bottomleft: 5px;
                text-align: right;
                /* ensure doesn't flow off the screen when expanded */
                max-height: 80%;
                overflow: auto; 
                z-index: 200;
            }
            #moochine-table-of-contents h2 {
                font-size: 10pt;
                max-width: 8em;
                font-weight: normal;
                padding-left: 0.5em;
                padding-top: 0.05em;
                padding-bottom: 0.05em; 
            }

            #moochine-table-of-contents ul {
                margin-left: 14pt; 
                margin-bottom: 10pt;
                padding: 0
            }

            #moochine-table-of-contents li {
                padding: 0;
                margin: 1px;
                list-style: none;
            }

            #moochine-table-of-contents #moochine-text-table-of-contents {
                display: none;
                text-align: left;
            }

            #moochine-table-of-contents:hover #moochine-text-table-of-contents {
                display: block;
                padding: 0.5em;
                margin-top: -1.5em; 
            }
            </style>
        ]==]

    