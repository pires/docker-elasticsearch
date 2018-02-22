# docker-elasticsearch

Ready to use, lean and highly configurable Elasticsearch container image.

[![Docker Repository on Quay.io](https://quay.io/repository/pires/docker-elasticsearch/status "Docker Repository on Quay.io")](https://quay.io/repository/pires/docker-elasticsearch)

## Current software

* OpenJDK JRE 8u151
* Elasticsearch 6.2.2

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
        quay.io/pires/docker-elasticsearch:6.2.2
```

Ready to use node for cluster `myclustername`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e CLUSTER_NAME=myclustername \
        quay.io/pires/docker-elasticsearch:6.2.2
```

Ready to use node for cluster `elasticsearch-default`, with 8GB heap allocated to Elasticsearch:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_JAVA_OPTS="-Xms8g -Xmx8g" \
        quay.io/pires/docker-elasticsearch:6.2.2
```

Ready to use node with plugins (x-pack and repository-gcs) pre installed. Already installed plugins are ignored:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_JAVA_OPTS="-Xms8g -Xmx8g" \
	-e ES_PLUGINS_INSTALL="repository-gcs,x-pack" \
        quay.io/pires/docker-elasticsearch:6.2.2
```

**Master-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_DATA=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:6.2.2
```

**Data-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach --volume /path/to/data_folder:/data \
	--privileged \
	-e NODE_MASTER=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:6.2.2
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
        quay.io/pires/docker-elasticsearch:6.2.2
```

**Client-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_MASTER=false \
	-e NODE_DATA=false \
        quay.io/pires/docker-elasticsearch:6.2.2
```
I also make available special images and instructions for [AWS EC2](https://github.com/pires/docker-elasticsearch-aws) and [Kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes).

### Environment variables

This image can be configured by means of environment variables, that one can set on a `Deployment`.

* [CLUSTER_NAME](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#cluster.name)
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
* [MEMORY_LOCK](https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#bootstrap.memory_lock) - memory locking control - enable to prevent swap (default = `true`) .
* [REPO_LOCATIONS](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html#_shared_file_system_repository) - list of registered repository locations. For example `["/backup"]` (default = `[]`).
* [PROCESSORS](https://github.com/elastic/elasticsearch-definitive-guide/pull/679/files) - allow elasticsearch to optimize for the actual number of available cpus (must be an integer - default = 1)

### Backup
Mount a shared folder (for example via NFS) to `/backup` and make sure the `elasticsearch` user
has write access. Then, set the `REPO_LOCATIONS` environment variable to `["/backup"]` and create
a backup repository:

`backup_repository.json`:
```
{
  "type": "fs",
  "settings": {
    "location": "/backup",
    "compress": true
  }
}
```

```bash
curl -XPOST http://<container_ip>:9200/_snapshot/nas_repository -d @backup_repository.json`
```

Now, you can take snapshots using:
```bash
curl -f -XPUT "http://<container_ip>:9200/_snapshot/nas_repository/snapshot_`date --utc +%Y_%m_%dt%H_%M`?wait_for_completion=true"
```
