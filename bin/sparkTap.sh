#!/usr/bin/env bash
set -v
# Stop
docker stop pytap

# Remove previuos container 
docker container rm pytap

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=pytap -e TAP_CODE=$1 -v tapvolume:/tapvolume  --network tap --name pytap -it tap:spark 