# docker-elasticsearch

Very lean (243MB) and highly configurable Elasticsearch Docker image, based on `progrium/busybox`.

## Current software

* Oracle JRE 8 Update 40
* Elasticsearch 1.5.0

## Pre-requisites

* Docker 1.5.0+ (tested with boot2docker)

## Build images (optional)

Providing your own version of [the images automatically built from this repository](https://registry.hub.docker.com/u/pires/docker-elasticsearch) is an *optional* step. You have been warned.

```
git clone https://github.com/pires/docker-elasticsearch.git
cd docker-elasticsearch
docker build -t pires/docker-elasticsearch .
```

## Run

You need a folder named `conf` with your own version of `elasticsearch.yml`. You can add other Elasticserach configuration files to this folder, such as `logging.yml`. If in doubt, take a look at the `conf` folder 

```
docker pull pires/docker-elasticsearch
docker run -d -v /path/to/conf_folder:/elasticsearch/conf pires/docker-elasticsearch
```

In case you want to specify a data folder so that Elasticsearch writes to storage outside the container, run
```
docker pull pires/docker-elasticsearch
docker run -d -v /path/to/conf_folder:/elasticsearch/conf -v /path/to/data_folder:/data pires/docker-elasticsearch
```