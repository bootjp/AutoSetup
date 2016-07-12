#!/bin/bash

# args 
# username userpassword
if [ $# -ne 2 ]; then
 echo "error"
 exit 1
fi

# ユーザー作成 ここではログイン不能ユーザの作成				
/usr/sbin/useradd -s /sbin/nologin $1

#ホームディレクトリのパーミッション変更		
chmod 711 /home/$1

# Disk quota のサンプルをコピー 
# DISK quotaを使っていない場合コメントアウト
edquota -p sample $1

# パスワード設定		
echo $1":"$2 | /usr/sbin/chpasswd

# MySQL ユーザー設定
mysql --user=root --password=mysql root password <<eof
create database $1;
grant all on $1.* to $1@localhost identified by '$2';
eof
