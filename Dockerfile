FROM pires/docker-jre
MAINTAINER pjpires@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV ES_PKG_NAME elasticsearch-1.5.2

# Install Elasticsearch.
RUN ( curl -Lskj https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv /$ES_PKG_NAME /elasticsearch && \
  rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))")

# Volume for Elasticsearch configuration
VOLUME ["/elasticsearch/config"]

# Volume for Elasticsearch data
VOLUME ["/data"]

CMD ["/elasticsearch/bin/elasticsearch"]
