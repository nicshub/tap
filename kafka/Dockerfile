FROM openjdk:8-jre-alpine
LABEL maintainer="Salvo Nicotra"
ENV PATH /opt/kafka/bin:$PATH
ENV KAFKA_DIR "/opt/kafka"
ARG KAFKA_VERSION="2.12-2.4.1"

RUN apk update && apk add --no-cache bash gcompat

# Installing Kafka
# ADD will automatically extract the file
ADD setup/kafka_${KAFKA_VERSION}.tgz /opt

# Create Sym Link 
RUN ln -s /opt/kafka_${KAFKA_VERSION} ${KAFKA_DIR} 

ADD kafka-manager.sh ${KAFKA_DIR}/bin/kafka-manager
# Copy All conf here
ADD conf/* ${KAFKA_DIR}/config/

ENTRYPOINT [ "kafka-manager" ]