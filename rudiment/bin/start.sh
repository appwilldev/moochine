# start nginx in app

NGINX_RUNTIME="nginx_runtime"
APP_PATH=`pwd`
APP_NAME=`basename $(APP_PATH)`

mkdir -p $NGINX_RUNTIME
mkdir -p $NGINX_RUNTIME"/logs"

#export OPENRESTY_HOME=/usr/local/openresty
#export MOOCHINE_HOME=/YOUR PATH/moochine
#export HADDIT_APP_CONFIG=/YOUR PATH/new_reddit/haddit.config


MOOCHINE_APP_EXTRA=$PWD

cat conf/nginx.conf | sed -e "s|__MOOCHINE_HOME_VALUE__|$MOOCHINE_HOME|"\
                    | sed -e "s|__MOOCHINE_APP_PATH_VALUE__|$APP_PATH|"\
                    | sed -e "s|__MOOCHINE_APP_NAME_VALUE__|$APP_NAME|"\
                    | sed -e "s|__HADDIT_APP_CONFIG__|$HADDIT_APP_CONFIG|"\
                    > $NGINX_RUNTIME/conf/p-nginx.conf

#$OPENRESTY_HOME/nginx/sbin/nginx -p `pwd`/ -c conf/p-nginx.conf
$OPENRESTY_HOME/nginx/sbin/nginx -p $NGINX_RUNTIME/ -c conf/p-nginx.conf

echo "start nginx!"


