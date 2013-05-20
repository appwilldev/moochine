#!/bin/bash

./bin/generate_nginx_conf.sh

PWD=`pwd`
NGINX_FILES=$PWD"/nginx_runtime"

kill -HUP $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx reloaded!"

