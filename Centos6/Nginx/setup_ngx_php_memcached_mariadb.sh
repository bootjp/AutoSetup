#!/bin/bash

# CentOS6 Auto Install Nginx MySQL PHP-FPM memcached and iptables setting
# Argument is "YoursiteDomain"
# Use ex. ./startup.sh example.com

if [ $# -ne 1 ]; then
 echo "argument is missing"
 exit 1
fi

cat <<"EOF" > /etc/sysconfig/iptables
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
-A INPUT -i ppp+ -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m limit --limit 1/sec -j ACCEPT
COMMIT
EOF
service iptables restart

yum -y install epel-release || exit 1
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm || exit 1
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm || exit 1

yum -y install --enablerepo=remi  php-fpm php-common php-mbstring php-xml php-gd php-mysql mysql-server php-devel php-pear php-pecl-memcache || exit 1
yum -y install nginx memcached || exit 1

# nginx basic setup

cat <<"EOF" > /etc/nginx/nginx.conf || exit 1
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    client_max_body_size 2G;

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;
    server_tokens    off;
    include /etc/nginx/conf.d/*.conf;
}
EOF

# nginx virtual host setup

cat <<EOF > /etc/nginx/conf.d/$1.conf || exit 1

server {
    listen       80;
    server_name  $1;

    #charset UTF-8;
    access_log  /var/log/nginx/$1.access.log  main;

    location / {
        root   /var/www/html/$1;
        index  index.html index.htm index.php;
        #必要に応じてコメントアウト
        #if (!-e $request_filename) {
        #    rewrite ^ /index.php last;
        #}
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
        root           /var/www/html/$1;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }
}
EOF

rm -f /etc/nginx/conf.d/default.conf || exit 1

# php-fpm setup
sed -i".org" "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf || exit 1
sed -i".org" "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf || exit 1

# file permissions change
mkdir -p /var/www/html/$1 || exit 1
chown -R nginx:nginx /var/www/html/ || exit 1
echo "<?php echo phpinfo();" > /var/www/html/$1/index.php || exit 1

# daemons start
service nginx start || exit 1
service php-fpm start || exit 1
service mysqld start || service mysql start || exit 1
service memcached start || exit 1
chkconfig nginx on || exit 1
chkconfig php-fpm on || exit 1
chkconfig mysqld on || chkconfig mysql on || exit 1
chkconfig memcached on || exit 1

echo "######################################################"
echo "   SET UP DONE TYPE $ curl -v http://localhost/       "
echo "######################################################"
