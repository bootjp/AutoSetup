#!/bin/bash

if [ $# -ne 2 ]; then
 echo "argument is missing"
 exit 1
fi

/usr/local/bin/wrk -t$2 -c$2 -d5m --timeout 5 $1
/usr/local/bin/wrk -t$2 -c$2 -d10m --timeout 5 $1
/usr/local/bin/wrk -t$2 -c$2 -d15m --timeout 5 $1
/usr/local/bin/wrk -t$2 -c$2 -d30m --timeout 5 $1
/usr/local/bin/wrk -t$2 -c$2 -d45m --timeout 5 $1
/usr/local/bin/wrk -t$2 -c$2 -d60m --timeout 5 $1
