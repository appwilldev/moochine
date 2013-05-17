#!/bin/bash

PWD=`pwd`
NGINX_FILES=$PWD"/nginx_runtime"

./bin/stop.sh

echo "" > $NGINX_FILES/logs/error.log

./bin/start.sh

echo "tail -f $NGINX_FILES/logs/error.log"
tail -f $NGINX_FILES/logs/error.log

