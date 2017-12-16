#!/bin/sh

BASE=/elasticsearch

# allow for memlock if enabled
if [ "$MEMORY_LOCK" == "true" ]; then
    ulimit -l unlimited
fi

# Set a random node name if not set.
if [ -z "${NODE_NAME}" ]; then
	NODE_NAME=$(uuidgen)
fi
export NODE_NAME=${NODE_NAME}

# Prevent "Text file busy" errors
sync

if [ ! -z "${ES_PLUGINS_INSTALL}" ]; then
   OLDIFS=$IFS
   IFS=','
   for plugin in ${ES_PLUGINS_INSTALL}; do
      if ! $BASE/bin/elasticsearch-plugin list | grep -qs ${plugin}; then
         yes | $BASE/bin/elasticsearch-plugin install --batch ${plugin}
      fi
   done
   IFS=$OLDIFS
fi

if [ ! -z "${SHARD_ALLOCATION_AWARENESS_ATTR}" ]; then
    # this will map to a file like  /etc/hostname => /dockerhostname so reading that file will get the
    #  container hostname
    if [ "$NODE_DATA" == "true" ]; then
        ES_SHARD_ATTR=`cat ${SHARD_ALLOCATION_AWARENESS_ATTR}`
        NODE_NAME="${ES_SHARD_ATTR}-${NODE_NAME}"
        echo "node.attr.${SHARD_ALLOCATION_AWARENESS}: ${ES_SHARD_ATTR}" >> $BASE/config/elasticsearch.yml
    fi
    if [ "$NODE_MASTER" == "true" ]; then
        echo "cluster.routing.allocation.awareness.attributes: ${SHARD_ALLOCATION_AWARENESS}" >> $BASE/config/elasticsearch.yml
    fi
fi

# run
chown -R elasticsearch:elasticsearch $BASE
chown -R elasticsearch:elasticsearch /data
exec su-exec elasticsearch $BASE/bin/elasticsearch
