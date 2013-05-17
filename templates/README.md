# OpenResty(ngx_lua)+Moochine 完整实例

这个项目演示了如何使用OpenResty和Moochine开发Web应用。

## 一、安装配置

### 1.1 OpenResty 安装
参看：http://openresty.org/#Installation
编译时选择luajit, `./configure --with-luajit`

### 1.2 Moochine 安装
    #Checkout Moochine 代码
    git clone git://github.com/appwilldev/moochine.git

### 1.3 配置环境变量
    #设置OpenResty环境变量
    export OPENRESTY_HOME=/usr/local/openresty

    #设置Moochine环境变量
    export MOOCHINE_HOME=/path/to/moochine

    #使环境变量生效
    source ~/.bashrc

    #将以上两个环境变量 加到 ~/.bashrc 或者~/.profile 里，下次登陆自动生效
    vim ~/.bashrc

## 二、示例(模版)程序
### 2.1 Checkout 示例代码
    git clone git://github.com/appwilldev/moochine-demo.git
    cd moochine-demo

### 2.2 程序目录结构
    moochine-demo #程序根目录
    |
    |-- routing.lua # URL Routing配置
    |-- application.lua # moochine app 描述文件
    |
    |-- app #应用目录
    |   `-- test.lua #请求处理函数
    |
    |-- bin #脚本目录
    |   |-- debug.sh #关闭服务->清空error log->启动服务->查看error log
    |   |-- reload.sh #平滑重载配置
    |   |-- start.sh #启动
    |   |-- stop.sh #关闭
    |   |-- console.sh #moochine控制台。注意:moochine控制台需要安装Python2.7或Python3.2。
    |   `-- cut_nginx_log_daily.sh #Nginx日志切割脚本
    |
    |-- conf  #配置目录
    |    `-- nginx.conf  #Nginx配置文件模版。需要配置 `set $MOOCHINE_APP_NAME 'moochine-demo';` 为真实App的名字。
    |
    |-- templates  #ltp模版目录
    |    `-- ltp.html  #ltp模版文件
    |
    |-- static  #静态文件(图片,css,js等)目录
    |    `-- main.js  #js文件
    |
    |-- moochine_demo.log #调试日志文件。在 application.lua 可以配置路径和Level。
    |
    `-- nginx_runtime #Nginx运行时目录。这个目录下的文件由程序自动生成，无需手动管理。
        |-- conf
        |   `-- p-nginx.conf #Nginx配置文件(自动生成)，执行 ./bin/start.sh 时会根据conf/nginx.conf 自动生成。
        |
        `-- logs #Nginx运行时日志目录
            |-- access.log #Nginx 访问日志
            |-- error.log #Nginx 错误日志
            `-- nginx.pid #Nginx进程ID文件

### 2.3 启动/停止/重载/重启 方法
    ./bin/start.sh #启动
    ./bin/stop.sh #停止
    ./bin/reload.sh #平滑重载配置
    ./bin/debug.sh #关闭服务->清空error log->启动服务->查看error log

注意：以上命令只能在程序根目录执行，类似 `./bin/xxx.sh` 的方式。

### 2.4 测试
    curl "http://localhost:9800/hello?name=xxxxxxxx"
    curl "http://localhost:9800/ltp"
    tail -f moochine_demo.log #查看 调试日志的输出
    tail -f nginx_runtime/logs/access.log  #查看 Nginx 访问日志的输出
    tail -f nginx_runtime/logs/error.log  #查看 Nginx 错误日志和调试日志 的输出

### 2.5 通过moochine控制台调试
    ./bin/console.sh #运行后会打开一个console，可以输入调试代码检查结果。注意:moochine控制台需要安装Python2.7或Python3.2。

## 三、开发Web应用
### 3.1 URL Routing: routing.lua
    #!/usr/bin/env lua
    -- -*- lua -*-
    -- copyright: 2012 Appwill Inc.
    -- author : ldmiao
    --

    local router = require('mch.router')
    router.setup()

    ---------------------------------------------------------------------
    map('^/hello%?name=(.*)',           'test.hello')
    ---------------------------------------------------------------------

### 3.2 请求处理函数：app/test.lua
请求处理函数接收2个参数，request和response，分别对应HTTP的request和response。从request对象拿到客户端发送过来的数据，通过response对象返回数据。

    #!/usr/bin/env lua
    -- -*- lua -*-
    -- copyright: 2012 Appwill Inc.
    -- author : ldmiao
    --

    module("test", package.seeall)

    local JSON = require("cjson")
    local Redis = require("resty.redis")

    function hello(req, resp, name)
        if req.method=='GET' then
            -- resp:writeln('Host: ' .. req.host)
            -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
            -- resp:writeln('name, ' .. req.uri_args['name'])
            resp.headers['Content-Type'] = 'application/json'
            resp:writeln(JSON.encode(req.uri_args))

            resp:writeln({{'a','c',{'d','e', {'f','b'})
        elseif req.method=='POST' then
            -- resp:writeln('POST to Host: ' .. req.host)
            req:read_body()
            resp.headers['Content-Type'] = 'application/json'
            resp:writeln(JSON.encode(req.post_args))
        end
    end

### 3.3 request对象的属性和方法
以下属性值的详细解释，可以通过 http://wiki.nginx.org/HttpLuaModule 和 http://wiki.nginx.org/HttpCoreModule 查找到。

    --属性
    method=ngx.var.request_method           -- http://wiki.nginx.org/HttpCoreModule#.24request_method
    schema=ngx.var.schema                   -- http://wiki.nginx.org/HttpCoreModule#.24scheme
    host=ngx.var.host                       -- http://wiki.nginx.org/HttpCoreModule#.24host
    hostname=ngx.var.hostname               -- http://wiki.nginx.org/HttpCoreModule#.24hostname
    uri=ngx.var.request_uri                 -- http://wiki.nginx.org/HttpCoreModule#.24request_uri
    path=ngx.var.uri                        -- http://wiki.nginx.org/HttpCoreModule#.24uri
    filename=ngx.var.request_filename       -- http://wiki.nginx.org/HttpCoreModule#.24request_filename
    query_string=ngx.var.query_string       -- http://wiki.nginx.org/HttpCoreModule#.24query_string
    user_agent=ngx.var.http_user_agent      -- http://wiki.nginx.org/HttpCoreModule#.24http_HEADER
    remote_addr=ngx.var.remote_addr         -- http://wiki.nginx.org/HttpCoreModule#.24remote_addr
    remote_port=ngx.var.remote_port         -- http://wiki.nginx.org/HttpCoreModule#.24remote_port
    remote_user=ngx.var.remote_user         -- http://wiki.nginx.org/HttpCoreModule#.24remote_user
    remote_passwd=ngx.var.remote_passwd     -- http://wiki.nginx.org/HttpCoreModule#.24remote_passwd
    content_type=ngx.var.content_type       -- http://wiki.nginx.org/HttpCoreModule#.24content_type
    content_length=ngx.var.content_length   -- http://wiki.nginx.org/HttpCoreModule#.24content_length

    headers=ngx.req.get_headers()           -- http://wiki.nginx.org/HttpLuaModule#ngx.req.get_headers
    uri_args=ngx.req.get_uri_args()         -- http://wiki.nginx.org/HttpLuaModule#ngx.req.get_uri_args
    post_args=ngx.req.get_post_args()       -- http://wiki.nginx.org/HttpLuaModule#ngx.req.get_post_args
    socket=ngx.req.socket                   -- http://wiki.nginx.org/HttpLuaModule#ngx.req.socket

    --方法
    request:read_body()                     -- http://wiki.nginx.org/HttpLuaModule#ngx.req.read_body
    request:get_uri_arg(name, default)
    request:get_post_arg(name, default)
    request:get_arg(name, default)

    request:get_cookie(key, decrypt)
    request:rewrite(uri, jump)              -- http://wiki.nginx.org/HttpLuaModule#ngx.req.set_uri
    request:set_uri_args(args)              -- http://wiki.nginx.org/HttpLuaModule#ngx.req.set_uri_args

### 3.4 response对象的属性和方法
    --属性
    headers=ngx.header                      -- http://wiki.nginx.org/HttpLuaModule#ngx.header.HEADER

    --方法
    response:set_cookie(key, value, encrypt, duration, path)
    response:write(content)
    response:writeln(content)
    response:ltp(template,data)
    response:redirect(url, status)          -- http://wiki.nginx.org/HttpLuaModule#ngx.redirect

    response:finish()                       -- http://wiki.nginx.org/HttpLuaModule#ngx.eof
    response:is_finished()
    response:defer(func, ...)               -- 在response返回后执行

### 3.5 打印调试日志
在 `application.lua` 里定义log文件的位置和Level

    logger:i(format, ...)  -- INFO
    logger:d(format, ...)  -- DEBUG
    logger:w(format, ...)  -- WARN
    logger:e(format, ...)  -- ERROR
    logger:f(format, ...)  -- FATAL
    -- format 和string.format(s, ...) 保持一致：http://www.lua.org/manual/5.1/manual.html#pdf-string.format

查看调试日志

    tail -f moochine_demo.log

查看nginx错误日志

    tail -f nginx_runtime/logs/error.log  #查看 Nginx 错误日志和调试日志 的输出

### 3.6 常见错误
1. MOOCHINE URL Mapping Error
1. Error while doing defers
1. Moochine ERROR

## 四、Multi-App 与 Sub-App

### 4.1 multi-app
    多个 moochine-app 可以运行与同一nginx进程中，只要将本例子中nginx.conf内moochine-app相关段配置多份即可。

### 4.2 sub-app
    某moochine-app可以作为另一app的sub-app运行，在主app的application.lua内配置：

    subapps={
        subapp1 = {path="/path/to/subapp1", config={}},
        ...
    }

## 五、参考
1. http://wiki.nginx.org/HttpLuaModule
1. http://wiki.nginx.org/HttpCoreModule
1. http://openresty.org
1. https://github.com/appwilldev/moochine

