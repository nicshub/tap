#!/usr/bin/env bash
REM Stop
docker stop tapflume

REM Remove previuos container 
docker container rm tapflume

#REM Build
docker build ..\flume\ --tag tap:flume

docker stop tapflume
#REM Run
docker run --network tap --ip 10.0.100.10  -it -e FLUME_CONF_FILE=twitterKafka.conf --name tapflume tap:flume