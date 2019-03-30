FROM zookeeper:latest
MAINTAINER Salvo Nicotra
ENV PATH /opt/zkui:$PATH

RUN apk update && apk add --no-cache bash 

RUN mkdir -p /opt/zkui
COPY lib/* /opt/zkui
COPY conf/* /opt/zkui
ADD zkui.sh /opt/zkui/zkui



EXPOSE 9090

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["zkui"]
