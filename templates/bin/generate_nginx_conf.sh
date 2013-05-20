#!/bin/bash

# set global variables
#export OPENRESTY_HOME=/usr/local/openresty

source `dirname $0`/mch-vars.sh

PWD=`pwd`

NGINX_FILES=$MOOCHINE_APP_PATH"/nginx_runtime"

mkdir -p $MOOCHINE_APP_PATH"/logs"
mkdir -p $NGINX_FILES"/conf"
mkdir -p $NGINX_FILES"/logs"

cp $MOOCHINE_APP_PATH"/conf/mime.types" $NGINX_FILES"/conf/"

sed -e "s|__MOOCHINE_HOME_VALUE__|$MOOCHINE_HOME|" \
    -e "s|__MOOCHINE_APP_NAME_VALUE__|$MOOCHINE_APP_NAME|" \
    -e "s|__MOOCHINE_APP_PATH_VALUE__|$MOOCHINE_APP_PATH|" \
    -e "s|__PWD__|$PWD|" \
    $MOOCHINE_APP_PATH/conf/nginx.conf > $NGINX_FILES/conf/p-nginx.conf
