FROM progrium/busybox
MAINTAINER pjpires@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV ES_PKG_NAME elasticsearch-1.5.0

# Udate wget to support SSL
RUN opkg-install wget

# Get and install JRE 8 Updated 40
RUN \
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/jre.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jre-8u40-linux-x64.tar.gz && \
  cd /opt && \
  gunzip /tmp/jre.tar.gz && \
  tar xf /tmp/jre.tar && \
  rm -f /tmp/jre.tar

# Link Java into use, wget-ssl updates libpthread which causes Java to break
RUN ln -sf /lib/libpthread-2.18.so /lib/libpthread.so.0
RUN ln -s /opt/jre1.8.0_40/bin/java /usr/bin/java

# Install Elasticsearch.
RUN \
  cd / && \
  wget --no-check-certificate --no-cookies https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  gunzip /$ES_PKG_NAME.tar.gz && \
  tar xf /$ES_PKG_NAME.tar && \
  rm -f /$ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Volume for Elasticsearch configuration
VOLUME ["/elasticsearch/config"]

# Volume for Elasticsearch data
VOLUME ["/data"]

CMD ["/elasticsearch/bin/elasticsearch"]
