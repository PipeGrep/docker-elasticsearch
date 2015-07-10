#
# Create for grep.so
#

FROM java:8
MAINTAINER Samuel BERTHE for Grep <pipe@grep.so>






# Install nginx
RUN             apt-get update && apt-get install -y ca-certificates nginx cron

# forward request and error logs to docker log collector
RUN             ln -sf /dev/stdout /var/log/nginx/access.log
RUN             ln -sf /dev/stderr /var/log/nginx/error.log

ADD             nginx.conf /etc/nginx/nginx.conf






# Install Elasticsearch.

ENV ES_PKG_NAME elasticsearch-1.6.0
ENV ES_IMPORTER_PATH http://xbib.org/repository/org/xbib/elasticsearch/importer/elasticsearch-jdbc/1.6.0.0/elasticsearch-jdbc-1.6.0.0-dist.zip
ENV ES_JDBCDRIVER_PATH https://jdbc.postgresql.org/download/postgresql-9.1-902.jdbc4.jar
ENV JDBC_IMPORTER_HOME /app/jdbc-importer


RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Mount elasticsearch.yml config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Add JDBC postgres driver
ADD $ES_IMPORTER_PATH $JDBC_IMPORTER_HOME/elasticsearch-jdbc.zip
RUN unzip $JDBC_IMPORTER_HOME/elasticsearch-jdbc.zip -d $JDBC_IMPORTER_HOME && mv $JDBC_IMPORTER_HOME/elasticsearch-jdbc-* $JDBC_IMPORTER_HOME/elasticsearch-jdbc
ADD $ES_JDBCDRIVER_PATH $JDBC_IMPORTER_HOME/elasticsearch-jdbc/lib/

# Add GUIs
RUN mkdir /data && mkdir /data/plugins ; mkdir /data/plugins/head && mkdir /data/plugins/HQ
RUN cd /data/plugins/HQ && wget https://github.com/royrusso/elasticsearch-HQ/archive/master.zip && unzip *.zip && mv *-master _site
RUN cd /data/plugins/head && wget https://github.com/mobz/elasticsearch-head/archive/master.zip && unzip *.zip && mv *-master _site
#RUN /elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ
#RUN /elasticsearch/bin/plugin --install mobz/elasticsearch-head







# Init indices and importers
ADD . /app
RUN chmod +x /app/start.sh /app/crontab.sh
RUN crontab /app/crontab.sh

# Define working directory.
WORKDIR /app
VOLUME ["/data"]

# Define default command.
CMD ["sh", "-c", "./start.sh"]

# Expose ports.
#   - 80: public
#   - 8080: admin
EXPOSE 80 8080
