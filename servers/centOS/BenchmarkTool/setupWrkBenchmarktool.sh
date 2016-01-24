#!/bin/bash

yum -y install gcc git openssl-devel

cd /tmp
git clone https://github.com/wg/wrk.git
cd wrk/
make
sudo cp wrk /usr/local/bin/

rm -rf /tmp/wrk
