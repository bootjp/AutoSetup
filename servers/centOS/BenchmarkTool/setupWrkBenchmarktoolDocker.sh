#!/bin/bash

yum -y install gcc git openssl-devel make
cd /tmp
git clone https://github.com/wg/wrk.git
cd wrk/
make
cp wrk /usr/local/bin/
rm -rf /tmp/wrk
