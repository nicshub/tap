#!/usr/bin/env bash
# Stop
docker stop sparkBash

# Remove previuos container 
docker container rm sparkBash

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=bash --network tap --name sparkBash -it tap:spark