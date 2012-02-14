.. MOCHINE README

MOOCHINE
=================

A (very) simple and lightweight web framework based on
`ngx-openresty <http://openresty.org/>`_.


How to use
-----------------

* Install ngx-openresty
* Checkout moochine source, place it to somewhere, suppose to /path/to/machine below
* There's a demo-app lies under the dir ``/path/to/moochine/demo``, you can run and test
  it after modifying these file:
  
  * demo/conf/nginx.conf (the nginx config file, you need change the MOOCHINE_HOME and
    MOOCHINE_APP var)
    
  * demo/app/routing.lua (url map using lua's ``string.match``)
  * demo/templates/* (`ltp templates <http://www.savarese.com/software/ltp/>`_)

Roadmap
-----------------

``Moochine`` is simple now, so there's no ``Roadmap`` for it at the moment, but any feature
request is welcome, just tell us, or make it out yourself.
  
  
License
------------------
This software is distributed under Apache License Version 2.0, see file ``LICENSE`` or
http://www.apache.org/licenses/LICENSE-2.0


