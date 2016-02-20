#!/usr/bin/env bash

# https://github.com/bootjp/AutoSetup/blob/master/servers/configs/etc/nginx/conf.d/docker_proxy.conf#L1-L8

docker rm -f $(docker ps | awk '/172.17.0.1:8080->80/ { print $1 }')
docker run -pd 172.17.0.1:8080:80 -e CI_ENV='production' hogehoge
docker rm -f $(docker ps | awk '/172.17.0.1:8000->80/ { print $1 }')
docker run -pd 172.17.0.1:8000:80 -e CI_ENV='production' hogehoge
docker rm -f $(docker ps | awk '/172.17.0.1:8800->80/ { print $1 }')
docker run -pd 172.17.0.1:8800:80 -e CI_ENV='production' hogehoge
docker rm -f $(docker ps | awk '/172.17.0.1:8888->80/ { print $1 }')
docker run -pd 172.17.0.1:8888:80 -e CI_ENV='production' hogehoge
