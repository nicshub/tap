#!/usr/bin/env bash
set -v
# Stop
docker stop tapnc
 
docker container rm tapnc

docker run -it --rm --network=tap --name tapnc --ip 10.0.100.42 subfuzion/netcat -vl $1