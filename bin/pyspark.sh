#!/usr/bin/env bash
# Stop
docker stop pyspark

# Remove previuos container 
docker container rm pyspark

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=pyspark --network tap --name pyspark -it tap:spark