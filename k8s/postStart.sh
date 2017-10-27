#!/bin/sh
while [ $(netstat -auntpl | grep LISTEN | grep -c 9300) -eq 0 ] ; do
  echo "waiting port to be opened"
  sleep 5
  pidof java || exit 1
done
exit 0
