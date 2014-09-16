#!/bin/sh

# 引数確認
if [ $# -ne 2 ]; then
 echo "error"
 exit 1
fi

# ユーザー作成 				
/usr/sbin/useradd -s /sbin/nologin $1

#ホームディレクトリのパーミッション変更		
chmod 711 /home/$1

# Disk quota のサンプルをコピー
edquota -p smple $1

# パスワード設定		
echo $1":"$2 | /usr/sbin/chpasswd

# MySQL ユーザー設定
mysql --user=root --password=[mysql root password] <<eof
create database $1;
grant all on $1.* to $1@localhost identified by '$2';
eof

