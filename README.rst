.. MOCHINE README

MOOCHINE
=================

A (very) simple and lightweight web framework based on
`ngx-openresty <http://openresty.org/>`_.

Download
------------------
git clone git://github.com/appwilldev/moochine.git

Changlog
------------------

v0.3
~~~~~~~~~~~~~~~~~~

* move `routing.lua` from app directory to app root directory
* `application.lua` for app config (in app root directory)  
* Multi-App support
* Sub-App support
* Facilities of logger and debug
  
How to use
-----------------

* Install ngx-openresty
* Checkout moochine source, place it to somewhere, suppose to /path/to/machine below
* There's some demo-apps under the dir ``/path/to/moochine/demos``, you can run and test
  them after modifying these file:
  
  * demo1/nginx_runtime/conf/nginx.conf (the nginx config file, you need change the MOOCHINE_HOME and
    MOOCHINE_APP_NAME var and MOOCHINE_APP_PATH var)
    
  * demo1/routing.lua (url map using lua's ``string.match``)
  * demo1/application.lua (moochine app config file)
  * demo1/templates/* (`ltp templates <http://www.savarese.com/software/ltp/>`_)


Demo
-----------------

A complete Demo
https://github.com/appwilldev/moochine-demo

Roadmap
-----------------

``Moochine`` is simple now, so there's no ``Roadmap`` for it at the moment, but any feature
request is welcome, just tell us, or make it out yourself.
  
  
License
------------------
This software is distributed under Apache License Version 2.0, see file ``LICENSE`` or
http://www.apache.org/licenses/LICENSE-2.0


