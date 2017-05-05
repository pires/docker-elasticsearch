FROM quay.io/pires/docker-jre:8u121
MAINTAINER pjpires@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV VERSION 5.3.2

# Install Elasticsearch.
RUN apk add --update bash curl ca-certificates sudo util-linux && \
  ( curl -Lskj https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$VERSION.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv /elasticsearch-$VERSION /elasticsearch && \
  rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$)") && \
  apk del curl

# Volume for Elasticsearch data
VOLUME ["/data"]

# Copy configuration
COPY config /elasticsearch/config

# Copy run script
COPY run.sh /

# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV MEMORY_LOCK true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV MAX_LOCAL_STORAGE_NODES 1
ENV SHARD_ALLOCATION_AWARENESS ""
ENV SHARD_ALLOCATION_AWARENESS_ATTR ""


CMD ["/run.sh"]
