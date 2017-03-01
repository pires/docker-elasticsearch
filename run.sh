#!/bin/sh

# provision elasticsearch user
addgroup sudo
adduser -D -g '' elasticsearch
adduser elasticsearch sudo
chown -R elasticsearch /elasticsearch /data
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# allow for memlock
ulimit -l unlimited

# Set a random node name if not set.
if [ -z "${NODE_NAME}" ]; then
	NODE_NAME=$(uuidgen)
fi
export NODE_NAME=${NODE_NAME}


# run
sudo -E -u elasticsearch /elasticsearch/bin/elasticsearch
