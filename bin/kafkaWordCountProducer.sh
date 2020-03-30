#!/usr/bin/env bash
docker run -e KAFKA_ACTION=producer -e KAFKA_TOPIC=streams-plaintext-input --network tap  -it tap:kafka