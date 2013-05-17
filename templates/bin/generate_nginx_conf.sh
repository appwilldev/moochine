#!/bin/bash

# set global variables
#export OPENRESTY_HOME=/usr/local/openresty
#export MOOCHINE_HOME=/your/path/to/moochine

PWD=`pwd`

NGINX_FILES=$PWD"/nginx_runtime"

mkdir -p $PWD"/logs"
mkdir -p $NGINX_FILES"/conf"
mkdir -p $NGINX_FILES"/logs"

cp $PWD"/conf/mime.types" $NGINX_FILES"/conf/"

sed -e "s|__MOOCHINE_HOME_VALUE__|$MOOCHINE_HOME|" \
    -e "s|__MOOCHINE_APP_PATH_VALUE__|$PWD|" \
    -e "s|__PWD__|$PWD|" \
    $PWD/conf/nginx.conf > $NGINX_FILES/conf/p-nginx.conf

