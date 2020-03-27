#!/usr/bin/env bash
# Stop
docker stop kafkaZK

# Remove previuos container 
docker container rm kafkaZK

docker build ../kafka/ --tag tap:kafka
docker run -e KAFKA_ACTION=start-zk --network tap --ip 10.0.100.22  -p 2181:2181 --name kafkaZK -it tap:kafka