#!/usr/bin/env bash

# https://github.com/bootjp/AutoSetup/blob/master/servers/configs/etc/nginx/conf.d/docker_proxy.conf#L1-L5

docker rm -f $(docker ps | awk '/0.0.0.0:8080->80/ { print $1 }')
docker run -pd 8080:80 -e CI_ENV='production' hogehoge
docker rm -f $(docker ps | awk '/0.0.0.0:8000->80/ { print $1 }')
docker run -pd 8000:80 -e CI_ENV='production' hogehoge