#!/bin/sh

# provision elasticsearch user
adduser -D -g '' elasticsearch
chown -R elasticsearch /elasticsearch /data

# allow for memlock
ulimit -l unlimited

# run
su-exec elasticsearch /elasticsearch/bin/elasticsearch
