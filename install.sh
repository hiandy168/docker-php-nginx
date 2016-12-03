#!/bin/bash

[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=$WEBSERVER_INSTALL_DIR/sbin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep $WEBSERVER_INSTALL_DIR /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=$WEBSERVER_INSTALL_DIR/sbin:\1@" /etc/profile

sed -i "s@/usr/local/nginx@$WEBSERVER_INSTALL_DIR@g" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
ldconfig

# proxy.conf
cat > $WEBSERVER_INSTALL_DIR/conf/proxy.conf << EOF
proxy_connect_timeout 300s;
proxy_send_timeout 900;
proxy_read_timeout 900;
proxy_buffer_size 32k;
proxy_buffers 4 64k;
proxy_busy_buffers_size 128k;
proxy_redirect off;
proxy_hide_header Vary;
proxy_set_header Accept-Encoding '';
proxy_set_header Referer \$http_referer;
proxy_set_header Cookie \$http_cookie;
proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
EOF

# logrotate nginx log
cat > /etc/logrotate.d/nginx << EOF
$WWWLOGS_DIR/*nginx.log {
  daily
  rotate 5
  missingok
  dateext
  compress
  notifempty
  sharedscripts
  postrotate
    [ -e /var/run/nginx.pid ] && kill -USR1 \`cat /var/run/nginx.pid\`
  endscript
}
EOF
