#!/bin/bash

PWD=`pwd`
NGINX_FILES=$PWD"/nginx_runtime"

kill -QUIT $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx stopped!"

