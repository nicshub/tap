#!/usr/bin/env bash
docker build ../kafka/ --tag tap:kafka
docker run -e KAFKA_ACTION=consumer -e KAFKA_TOPIC=tap --network tap   -it tap:kafka