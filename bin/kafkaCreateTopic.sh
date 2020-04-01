#!/usr/bin/env bash
set -v
# Stop
docker stop kafkaTopic

# Remove previuos container 
docker container rm kafkaTopic

docker build ../kafka/ --tag tap:kafka
docker run -e KAFKA_ACTION=create-topic -e KAKFA_SERVER=10.0.100.23 -e KAFKA_TOPIC=$1 --network tap --ip 10.0.100.24 --name kafkaTopic -it tap:kafka