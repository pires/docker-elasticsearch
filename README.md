# docker-elasticsearch

Very lean (205MB) and highly configurable Elasticsearch Docker image, based on `progrium/busybox`.

[![Docker Repository on Quay.io](https://quay.io/repository/pires/docker-elasticsearch/status "Docker Repository on Quay.io")](https://quay.io/repository/pires/docker-elasticsearch)

## Current software

* Oracle JRE 8 Update 45
* Elasticsearch 1.5.2

## Pre-requisites

* Docker 1.5.0+

## Run

You need a folder named `config` with your own version of `elasticsearch.yml`. You can add other Elasticserach configuration files to this folder, such as `logging.yml`. If in doubt, take a look at the `config` folder 

```
docker run --rm -v /path/to/config:/elasticsearch/config quay.io/pires/docker-elasticsearch:1.5.2
```

In case you want to specify a data folder so that Elasticsearch writes to storage outside the container, run
```
docker run --rm -v /path/to/config:/elasticsearch/config -v /path/to/data_folder:/data quay.io/pires/docker-elasticsearch:1.5.2
```
