REM Stop
docker stop kafkaZK

REM Remove previuos container 
docker container rm kafkaZK

docker build ..\kafka\ --tag tap:kafka
docker stop kafkaZK
docker run -e KAFKA_ACTION=start-zk --network tap --ip 10.0.100.22  -p 2181:2181 --name kafkaZK -it tap:kafka