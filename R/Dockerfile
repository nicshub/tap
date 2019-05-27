FROM r-base
ENV PATH /usr/local/src/myscripts/:$PATH
COPY r-manager.sh /usr/local/src/myscripts/r-manager
COPY scripts/* /usr/local/src/myscripts/
# Install packages
RUN apt-get update && apt-get install libxml2 libxml2-dev
RUN Rscript -e "install.packages('xml2')"
RUN Rscript -e "install.packages('e1071')"
RUN Rscript -e "install.packages('tm')"
RUN Rscript -e "install.packages('optparse')"
RUN Rscript -e "install.packages('SnowballC')"

WORKDIR /usr/local/src/myscripts
ENTRYPOINT [ "r-manager" ]