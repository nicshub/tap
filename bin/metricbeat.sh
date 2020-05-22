#!/usr/bin/env bash
# Stop
docker stop metricbeat

#  Remove previuos container 
docker container rm metricbeat

# Build
docker build ../metricbeat/ --tag tap:metricbeat
 
docker run --ip 10.0.100.53  --network tap tap:metricbeat
