REM Stop
docker stop kafkaTopic

REM Remove previuos container 
docker container rm kafkaTopic

docker build ..\kafka\ --tag tap:kafka
docker run -e KAFKA_ACTION=create-topic -e KAKFA_SERVER=10.0.100.23 -e KAFKA_TOPIC=tap --network tap --ip 10.0.100.24 --name kafkaTopic -it tap:kafka