# docker-elasticsearch

Very lean (151MB) and highly configurable Elasticsearch Docker image.

[![Docker Repository on Quay.io](https://quay.io/repository/pires/docker-elasticsearch/status "Docker Repository on Quay.io")](https://quay.io/repository/pires/docker-elasticsearch)

## Current software

* [OpenJDK 8u72](http://openjdk.java.net/projects/jdk8u/releases/8u72.html)
* Elasticsearch 2.3.0

## Run

**Note:** In order for `bootstrap.mlockall` to work, `ulimit` must be allowed to run in the container. Run with `--privileged` to enable this.

Ready to use node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
        quay.io/pires/docker-elasticsearch:2.3.0
```

Ready to use node for cluster `myclustername`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e CLUSTER_NAME=myclustername \
        quay.io/pires/docker-elasticsearch:2.3.0
```

Ready to use node for cluster `elasticsearch-default`, with 8GB heap allocated to Elasticsearch:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e ES_HEAP_SIZE=8G \
        quay.io/pires/docker-elasticsearch:2.3.0
```

**Master-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_DATA=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:2.3.0
```

**Data-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach --volume /path/to/data_folder:/data \
	--privileged \
	-e NODE_MASTER=false \
	-e HTTP_ENABLE=false \
        quay.io/pires/docker-elasticsearch:2.3.0
```

**Client-only** node for cluster `elasticsearch-default`:
```
docker run --name elasticsearch \
	--detach \
	--privileged \
	--volume /path/to/data_folder:/data \
	-e NODE_MASTER=false \
	-e NODE_DATA=false \
        quay.io/pires/docker-elasticsearch:2.3.0
```

I also make available special images and instructions for [AWS EC2](https://github.com/pires/docker-elasticsearch-aws) and [Kubernetes](https://github.com/pires/docker-elasticsearch-kubernetes).
