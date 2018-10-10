#!/bin/sh

echo "Starting Elasticsearch ${ES_VERSION}"

BASE=/elasticsearch

# Allow for memlock if enabled
if [ "${MEMORY_LOCK}" == "true" ]; then
    ulimit -l unlimited
fi

# Set a random node name if not set
if [ -z "${NODE_NAME}" ]; then
    NODE_NAME="$(uuidgen)"
fi
export NODE_NAME="${NODE_NAME}"

# Create a temporary folder for Elasticsearch ourselves
# ref: https://github.com/elastic/elasticsearch/pull/27659
export ES_TMPDIR="$(mktemp -d -t elasticsearch.XXXXXXXX)"

# Prevent "Text file busy" errors
sync

if [ ! -z "${ES_PLUGINS_INSTALL}" ]; then
    OLDIFS="${IFS}"
    IFS=","
    for plugin in ${ES_PLUGINS_INSTALL}; do
        if ! "${BASE}"/bin/elasticsearch-plugin list | grep -qs ${plugin}; then
            until "${BASE}"/bin/elasticsearch-plugin install --batch ${plugin}; do
                echo "Failed to install ${plugin}, retrying in 3s"
                sleep 3
            done
        fi
    done
    IFS="${OLDIFS}"
fi

if [ ! -z "${SHARD_ALLOCATION_AWARENESS_ATTR}" ]; then
    # This will map to a file like  /etc/hostname => /dockerhostname so reading that file will get the
    # container hostname
    if [ "${NODE_DATA}" == "true" ]; then
        ES_SHARD_ATTR="$(cat ${SHARD_ALLOCATION_AWARENESS_ATTR})"
        NODE_NAME="${ES_SHARD_ATTR}-${NODE_NAME}"
        echo "node.attr.${SHARD_ALLOCATION_AWARENESS}: ${ES_SHARD_ATTR}" >> "${BASE}"/config/elasticsearch.yml
    fi
    if [ "$NODE_MASTER" == "true" ]; then
        echo "cluster.routing.allocation.awareness.attributes: ${SHARD_ALLOCATION_AWARENESS}" >> "${BASE}"/config/elasticsearch.yml
    fi
fi

# Remove x-pack-ml module
rm -rf \
    /elasticsearch/modules/x-pack/x-pack-ml \
    /elasticsearch/modules/x-pack-ml

# Run
if [[ $(whoami) == "root" ]]; then
    echo "Changing ownership of ${BASE} folder"
    find "${BASE}" -type f -print0 | xargs -0 chown elasticsearch:elasticsearch

    echo "Changing ownership of /data folder"
    find /data -type f -print0 | xargs -0 chown elasticsearch:elasticsearch
	
    exec su-exec elasticsearch "${BASE}"/bin/elasticsearch ${ES_EXTRA_ARGS}
else
    # The container's first process is not running as 'root', 
    # it does not have the rights to chown. However, we may
    # assume that it is being ran as 'elasticsearch', and that
    # the volumes already have the right permissions. This is
    # the case for Kubernetes, for example, when 'runAsUser: 1000'
    # and 'fsGroup:100' are defined in the pod's security context.
    "${BASE}"/bin/elasticsearch ${ES_EXTRA_ARGS}
fi
