# docker-elasticsearch

Very lean (140MB) and highly configurable Elasticsearch Docker image.

[![Docker Repository on Quay.io](https://quay.io/repository/pires/docker-elasticsearch/status "Docker Repository on Quay.io")](https://quay.io/repository/pires/docker-elasticsearch)

## Current software

* [OpenJDK 8u92](http://openjdk.java.net/projects/jdk8u/releases/8u92.html)
* Elasticsearch 2.4.1

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
        quay.io/pires/docker-elasticsearch:2.4.1
```

Ready to use node for cluster `myclustername`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e CLUSTER_NAME=myclustername \
        quay.io/pires/docker-elasticsearch:2.4.1
```

Ready to use node for cluster `elasticsearch-default`, with 8GB heap allocated to Elasticsearch:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_HEAP_SIZE=8G \
        quay.io/pires/docker-elasticsearch:2.4.1
```

**Master-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_DATA=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:2.4.1
```

**Data-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach --volume /path/to/data_folder:/data \
	--privileged \
	-e NODE_MASTER=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:2.4.1
```

**Client-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_MASTER=false \
	-e NODE_DATA=false \
        quay.io/pires/docker-elasticsearch:2.4.1
```

I also make available special images and instructions for [AWS EC2](https://github.com/pires/docker-elasticsearch-aws) and [Kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes).

### Environment variables

This image can be configured by means of environment variables, that one can set on a `Deployment`.

* [CLUSTER_NAME](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration.html#cluster-name)
* [NODE_MASTER](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#master-node)
* [NODE_DATA](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#data-node)
* [NETWORK_HOST](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html#common-network-settings)
* [HTTP_ENABLE](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [HTTP_CORS_ENABLE](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [HTTP_CORS_ALLOW_ORIGIN](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#_settings_2)
* [NUMBER_OF_MASTERS](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-zen.html#master-election)
* [NUMBER_OF_SHARDS](https://www.elastic.co/guide/en/elasticsearch/guide/current/_index_settings.html)
* [NUMBER_OF_REPLICAS](https://www.elastic.co/guide/en/elasticsearch/guide/current/_index_settings.html)
* [ES_HEAP_SIZE](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/heap-sizing.html)
