FROM  docker.elastic.co/beats/metricbeat:7.7.0
MAINTAINER Salvo Nicotra
COPY modules/* /usr/share/metricbeat/modules.d/
USER root
RUN chmod go-w /usr/share/metricbeat/modules.d/metricbeat.docker.yml
RUN chown root:metricbeat /usr/share/metricbeat/modules.d/metricbeat.docker.yml
USER metricbeat
