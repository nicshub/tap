FROM openjdk:8-jre-alpine
MAINTAINER Salvo Nicotra
ENV PATH /opt/kafka/bin:$PATH
ENV KAFKA_DIR "/opt/kafka"
ARG KAFKA_PKG="kafka_2.11-2.1.0"

RUN apk update && apk add --no-cache bash 

# Installing Kafka
# ADD will automatically extract the file
ADD setup/${KAFKA_PKG}.tgz /opt

# Create Sym Link 
RUN ln -s /opt/kafka_2.11-2.1.0 ${KAFKA_DIR} 

ADD kafka-manager.sh ${KAFKA_DIR}/bin/kafka-manager
# Copy All conf here
ADD conf/* ${KAFKA_DIR}/config/

ENTRYPOINT [ "kafka-manager" ]