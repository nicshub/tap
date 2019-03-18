REM Network
docker network create --subnet=10.0.100.1/24 tap
REM Build
docker build ..\flume\ --tag tap:flume

REM Run
docker run --network tap --ip 10.0.100.10 -p 44444:44444 -it -e FLUME_CONF_FILE=netcatFileSink.conf tap:flume