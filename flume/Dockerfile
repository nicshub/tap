FROM openjdk:8-jre-alpine
MAINTAINER Salvo Nicotra
ENV PATH /opt/flume/bin:$PATH

RUN apk update \
    && apk add --no-cache wget bash \
    && mkdir -p /opt/flume && wget -qO- http://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz | tar zxvf - -C /opt/flume --strip 1

ENV HADOOP_VERSION=2.10.0
ENV HADOOP_HOME=/opt/flume/lib/hadoop-$HADOOP_VERSION

RUN wget -q http://www.eu.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /opt/flume/lib/hadoop-$HADOOP_VERSION.tar.gz && \
    tar xzf /opt/flume/lib/hadoop-$HADOOP_VERSION.tar.gz -C /opt/flume/lib && \
    rm /opt/flume/lib/hadoop-$HADOOP_VERSION.tar.gz

RUN mkdir /var/log/netcat
ADD start-flume.sh /opt/flume/bin/start-flume
# Copy All conf here
ADD conf/* /opt/flume/conf/
# Add compiled lib
ADD lib/* /opt/flume/lib/
EXPOSE 44444

ENTRYPOINT [ "start-flume" ]