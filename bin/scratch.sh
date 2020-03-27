#!/usr/bin/env bash
docker stop tapscratch

REM Remove previuos container 
docker container rm tapscratch

#REM Build
docker build ../scratch/ --tag tapscratch

docker run -p 80:80 tapscratch
