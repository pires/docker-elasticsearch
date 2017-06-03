# docker-elasticsearch

Lean (128MB) and highly configurable Elasticsearch Docker image.

[![Docker Repository on Quay.io](https://quay.io/repository/pires/docker-elasticsearch/status "Docker Repository on Quay.io")](https://quay.io/repository/pires/docker-elasticsearch)

## Current software

* OpenJDK JRE 8u131
* Elasticsearch 5.4.1

## Run

### Attention

* In order for `bootstrap.mlockall` to work, `ulimit` must be allowed to run in the container. Run with `--privileged` to enable this.
* [Multicast discovery is no longer built-in](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/breaking_20_removed_features.html#_multicast_discovery_is_now_a_plugin)

Ready to use node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
        quay.io/pires/docker-elasticsearch:5.4.1
```

Ready to use node for cluster `myclustername`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e CLUSTER_NAME=myclustername \
        quay.io/pires/docker-elasticsearch:5.4.1
```

Ready to use node for cluster `elasticsearch-default`, with 8GB heap allocated to Elasticsearch:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_JAVA_OPTS="-Xms8g -Xmx8g" \
        quay.io/pires/docker-elasticsearch:5.4.1
```

Ready to use node with plugins (x-pack and repository-gcs) pre installed. Already installed plugins are ignored:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_JAVA_OPTS="-Xms8g -Xmx8g" \
	-e ES_PLUGINS_INSTALL="repository-gcs,x-pack" \
        quay.io/pires/docker-elasticsearch:5.4.1
```

**Master-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_DATA=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:5.4.1
```

**Data-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach --volume /path/to/data_folder:/data \
	--privileged \
	-e NODE_MASTER=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:5.4.1
```

**Data-only** node for cluster `elasticsearch-default` with shard allocation awareness:
```
docker run --name elasticsearch \
	--detach --volume /path/to/data_folder:/data \
        --volume /etc/hostname:/dockerhost \
	--privileged \
	-e NODE_MASTER=false \
	-e HTTP_ENABLE=false \
    -e SHARD_ALLOCATION_AWARENESS=dockerhostname \
    -e SHARD_ALLOCATION_AWARENESS_ATTR="/dockerhost" \
        quay.io/pires/docker-elasticsearch:5.4.1
```

**Client-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_MASTER=false \
	-e NODE_DATA=false \
        quay.io/pires/docker-elasticsearch:5.4.1
```
I also make available special images and instructions for [AWS EC2](https://github.com/pires/docker-elasticsearch-aws) and [Kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes).

### Environment variables

This image can be configured by means of environment variables, that one can set on a `Deployment`.

* [CLUSTER_NAME](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration.html#cluster-name)
* [NODE_NAME](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#node.name)
* [NODE_MASTER](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#master-node)
* [NODE_DATA](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#data-node)
* [NETWORK_HOST](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html#network-interface-values)
* [HTTP_ENABLE](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [HTTP_CORS_ENABLE](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [HTTP_CORS_ALLOW_ORIGIN](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [NUMBER_OF_MASTERS](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-zen.html#master-election)
* [MAX_LOCAL_STORAGE_NODES](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#max-local-storage-nodes)
* [ES_JAVA_OPTS](https://www.elastic.co/guide/en/elasticsearch/reference/current/heap-size.html)
* [ES_PLUGINS_INSTALL](https://www.elastic.co/guide/en/elasticsearch/plugins/current/installation.html) - comma separated list of Elasticsearch plugins to be installed. Example: `ES_PLUGINS_INSTALL="repository-gcs,x-pack"`
* [SHARD_ALLOCATION_AWARENESS](https://www.elastic.co/guide/en/elasticsearch/reference/current/allocation-awareness.html#CO287-1)
* [SHARD_ALLOCATION_AWARENESS_ATTR](https://www.elastic.co/guide/en/elasticsearch/reference/current/allocation-awareness.html#CO287-1)
