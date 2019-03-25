FROM openjdk:8-jre-alpine
MAINTAINER Salvo Nicotra
ENV PATH /opt/flume/bin:$PATH

RUN apk update \
    && apk add --no-cache wget bash \
    && mkdir -p /opt/flume && wget -qO- http://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz | tar zxvf - -C /opt/flume --strip 1

RUN mkdir /var/log/netcat
ADD start-flume.sh /opt/flume/bin/start-flume
# Copy All conf here
ADD conf/* /opt/flume/conf/
# Add compiled lib
ADD lib/* /opt/flume/lib/
EXPOSE 44444

ENTRYPOINT [ "start-flume" ]