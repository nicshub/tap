REM Stop
docker stop pythonTwitterKafkaConsumer

REM Remove previuos container 
docker container rm pythonTwitterKafkaConsumer

docker build ..\python\ --tag tap:python
docker run --network tap --ip 10.0.100.41 --name pythonTwitterKafkaConsumer -it tap:python