FROM r-base
ENV PATH /usr/local/src/myscripts/:$PATH
COPY r-manager.sh /usr/local/src/myscripts/r-manager
COPY scripts/* /usr/local/src/myscripts/
# Install packages
RUN apt-get update && apt-get -y install libxml2 libxml2-dev default-jdk
RUN Rscript -e "install.packages('xml2')"
RUN Rscript -e "install.packages('e1071')"
RUN Rscript -e "install.packages('tm')"
RUN Rscript -e "install.packages('optparse')"
RUN Rscript -e "install.packages('SnowballC')"
RUN Rscript -e "install.packages('rJava')"
RUN Rscript -e "install.packages('rkafkajars')"
RUN Rscript -e "install.packages('rkafka')"
RUN Rscript -e "install.packages('rjson')"
RUN Rscript -e "install.packages('stringi')"

WORKDIR /usr/local/src/myscripts
ENTRYPOINT [ "r-manager" ]