#!/usr/bin/env bash
# Stop
docker stop sparkSubmit

# Remove previuos container 
docker container rm sparkSubmit

docker build ../spark/ --tag tap:spark
docker run -e SPARK_ACTION=spark-submit-python -p 4040:4040 --network tap --name sparkSubmit -it tap:spark $1 $2