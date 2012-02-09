export OPENRESTY_HOME=$HOME/Developer/openresty
$OPENRESTY_HOME/nginx/sbin/nginx -p `pwd`/demo/ -c conf/nginx.conf -s reload
