#
# Create for grep.so
#

FROM java:8
MAINTAINER Samuel BERTHE for Grep <pipe@grep.so>






ENV ES_PKG_NAME elasticsearch-1.4.1

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Mount elasticsearch.yml config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml


# Add JDBC postgres driver
#RUN mkdir /data/data ; mkdir /data/log ; mkdir /data/plugins ; mkdir /data/plugins/river-jdbc ; mkdir /data/work
RUN /elasticsearch/bin/plugin --install jdbc --url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/1.4.0.10/elasticsearch-river-jdbc-1.4.0.10.zip
ADD https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar /data/plugins/river-jdbc/


# Add GUIs
RUN /elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ
RUN /elasticsearch/bin/plugin --install mobz/elasticsearch-head







# Install nginx
RUN             apt-get update && apt-get install -y ca-certificates nginx cron

# forward request and error logs to docker log collector
RUN             ln -sf /dev/stdout /var/log/nginx/access.log
RUN             ln -sf /dev/stderr /var/log/nginx/error.log

ADD             nginx.conf /etc/nginx/nginx.conf







# Init indices and rivers
RUN mkdir /app
ADD . /app
RUN chmod +x /app/start.sh /app/crontab.sh
RUN crontab /app/crontab.sh

# Define working directory.
WORKDIR /app
VOLUME ["/data"]

# Define default command.
CMD ["sh", "-c", "./start.sh"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 80 8080
