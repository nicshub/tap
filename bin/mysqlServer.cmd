#!/usr/bin/env bash
REM Stop
docker stop tapmysql

REM Remove previuos container 
docker container rm tapmysql
docker run --network tap --ip 10.0.100.31 --name tapmysql -e MYSQL_ROOT_PASSWORD=tap -p 3306:3306 -d mysql:5.7
