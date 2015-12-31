#!/bin/bash

# 0 4 */10 * * /root/encrypt.sh

cd /root/letsencrypt

./letsencrypt-auto --renew certonly --webroot -d bootjp.me --webroot-path /var/www/bootjp.me/
status=$?
if [ $status -ne 0 ]; then
  echo "letsencrypt bootjp.me Error!!"
  exit 1
fi

/usr/sbin/nginx -t
status=$?
if [ $status -eq 0 ]; then
  systemctl reload nginx
else
  echo "Nginx Error!!"
  exit 1
fi

./letsencrypt-auto --renew certonly --webroot -d st.bootjp.me --webroot-path /var/www/bootjp.me/wp-content/uploads/
status=$?
if [ $status -ne 0 ]; then
  echo "letsencrypt st.bootjp.me Error!!"
  exit 1
fi

/usr/sbin/nginx -t
status=$?
if [ $status -eq 0 ]; then
  systemctl reload nginx
else
  echo "Nginx Error!!"
  exit 1
fi

./letsencrypt-auto --renew certonly --webroot -d www.bootjp.me --webroot-path /var/www/bootjp.me/
status=$?
if [ $status -ne 0 ]; then
  echo "letsencrypt www.bootjp.me Error!!"
  exit 1
fi

/usr/sbin/nginx -t
status=$?
if [ $status -eq 0 ]; then
  systemctl reload nginx
else
  echo "Nginx Error!!"
  exit 1
fi
