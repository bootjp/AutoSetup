#!/bin/bash

TODAY=`TZ=JST-9 date +%Y%m%d`

mysqldump -h [Hostname] -p[Password]  -u[User] --all-databases --events --single-transaction --skip-lock-tables --skip-dump-date --quick > /root/RDS_BACKUP/bootjp.me.sql.gz

cd /root/RDS_BACKUP/
git add -A
git commit -m "backup$TODAY"
git push origin master

cd /var/www/bootjp.me/
git add -A
git commit -m "backup$TODAY"
git push origin backup

echo 3 > /proc/sys/vm/drop_caches