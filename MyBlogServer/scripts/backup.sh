#!/bin/bash

TODAY=`TZ=JST-9 date +%Y%m%d`

mysqldump -h [Hostname] -p[Password]  -u[User] --all-databases --events --single-transaction --skip-lock-tables --skip-dump-date --quick > /root/RDS_BACKUP/bootjp.me.sql

cd /root/RDS_BACKUP/
git add -A
git commit -m "backup$TODAY"
git push origin master

cd /var/www/bootjp.me/
git add -A
git commit -m "backup$TODAY"
git push origin backup

echo 3 > /proc/sys/vm/drop_caches

yum -y update
yum -y update --enablerepo=remi --enablerepo=remi-php56

cd /root/letsencrypt

./letsencrypt-auto --renew certonly --webroot -d bootjp.me --webroot-path /var/www/bootjp.me/
status=$?
if [ $status -ne 0 ]; then
  echo "letsencrypt bootjp.me Error!!"
  exit 1
fi

nginx -t
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

nginx -t
status=$?
if [ $status -eq 0 ]; then
  systemctl reload nginx
  else
  echo "Nginx Error!!"
  exit 1
fi
