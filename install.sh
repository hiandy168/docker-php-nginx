#!/bin/bash

[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=$WEBSERVER_INSTALL_DIR/sbin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep $WEBSERVER_INSTALL_DIR /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=$WEBSERVER_INSTALL_DIR/sbin:\1@" /etc/profile

sed -i "s@/usr/local/nginx@$WEBSERVER_INSTALL_DIR@g" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
ldconfig