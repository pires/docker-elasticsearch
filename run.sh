#!/bin/sh

chown -R elasticsearch /elasticsearch /data

# allow for memlock
ulimit -l unlimited

# run
su-exec elasticsearch /elasticsearch/bin/elasticsearch
