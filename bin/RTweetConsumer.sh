#!/usr/bin/env bash
REM Stop
docker stop RTapTweetConsumer

REM Remove previuos container 
docker container rm RTapTweetConsumer

docker build ../R/ --tag tap:RTapTweetConsumer
docker run --network tap -e R_ACTION=tapconsumer --name RTapTweetConsumer -it tap:RTapTweetConsumer