FROM ubuntu

RUN apt-get update && apt-get install -y goaccess && touch /usr/local/apache2/access.log

COPY public_html/* /usr/local/apache2/htdocs/
COPY conf/* /usr/local/apache2/conf/

#ENTRYPOINT  ["goaccess","/usr/local/apache2/access.log", "-o /usr/local/apache2/htdocs/report.html", "--log-format=COMBINED", "--real-time-html"]