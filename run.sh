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

if [ ! -z "${ES_PLUGINS_INSTALL}" ]; then
   OLDIFS=$IFS
   IFS=','
   for plugin in ${ES_PLUGINS_INSTALL}; do
      if ! /elasticsearch/bin/elasticsearch-plugin list | grep -qs ${plugin}; then
         yes | /elasticsearch/bin/elasticsearch-plugin install --batch ${plugin}
      fi
   done
   IFS=$OLDIFS
fi

# run
sudo -E -u elasticsearch /elasticsearch/bin/elasticsearch
