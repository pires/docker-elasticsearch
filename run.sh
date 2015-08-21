#!/bin/sh

export CLUSTER_NAME=${CLUSTER_NAME:-elasticsearch-default}
export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_ENABLE=${HTTP_ENABLE:-true}
export MULTICAST=${MULTICAST:-true}

/elasticsearch/bin/elasticsearch