FROM httpd:2.4
MAINTAINER Salvo Nicotra
ENV PATH /opt/flume/bin:/usr/local/openjdk/jdk11/bin:$PATH

RUN apt-get update && apt-get -y install curl 

# Install Java
RUN mkdir -p /usr/local/openjdk11/ && curl "https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz" | tar zx
vf - -C /usr/local/openjdk
# Install Flume
RUN mkdir -p /opt/flume && curl http://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz | tar zxvf - -C /opt/flume --strip 1

COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./public-html/ /usr/local/apache2/htdocs/

#ADD start-flume.sh /opt/flume/bin/start-flume
# Copy All conf here
#ADD conf/* /opt/flume/conf/
EXPOSE 80

#ENTRYPOINT [ "bash" ]