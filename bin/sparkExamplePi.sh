#!/usr/bin/env bash
# Stop
docker stop sparkPi

# Remove previuos container 
docker container rm sparkPi

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=example --network tap --name sparkPi -it tap:spark SparkPi 100