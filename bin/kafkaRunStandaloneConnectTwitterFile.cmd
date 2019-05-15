REM Stop
docker stop kafkaConnectorTwitterFile

REM Remove previuos container 
docker container rm kafkaConnectorTwitterFile

docker build ..\kafka\ --tag tap:kafka
docker run -e KAFKA_ACTION=connect-standalone -e KAFKA_WORKER_PROPERTIES=connectStandaloneStringTwitter.properties -e KAFKA_CONNECTOR_PROPERTIES=mysqlSinkTwitter.conf --network tap --ip 10.0.100.25 --name kafkaConnectorTwitterFile -it tap:kafka