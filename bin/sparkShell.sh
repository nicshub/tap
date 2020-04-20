#!/usr/bin/env bash
# Stop
docker stop sparkShell

# Remove previuos container 
docker container rm sparkShell

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=spark-shell --network tap --name sparkShell -it tap:spark