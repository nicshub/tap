#!/usr/bin/env bash
# Stop
docker stop sparkSubmitApp

# Remove previuos container 
docker container rm sparkSubmitApp

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=spark-submit-apps --network tap --name sparkSubmitApp -it tap:spark $1 $2 $3