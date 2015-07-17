#!/bin/bash

if [ $# -ne 1 ]; then
 echo "argument is missing"
 exit 1
fi

/usr/local/bin/wrk -t75 -c75 -d5m --timeout 5 $1
/usr/local/bin/wrk -t75 -c75 -d10m --timeout 5 $1
/usr/local/bin/wrk -t75 -c75 -d15m --timeout 5 $1
/usr/local/bin/wrk -t75 -c75 -d30m --timeout 5 $1
/usr/local/bin/wrk -t75 -c75 -d45m --timeout 5 $1
/usr/local/bin/wrk -t75 -c75 -d60m --timeout 5 $1
