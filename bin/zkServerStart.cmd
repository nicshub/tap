REM Stop
docker stop kafkaZookeeperWebUI

REM Remove previuos container 
docker container rm kafkaZookeeperWebUI

docker build ..\zookeeper\ --tag tap:zookeeper
docker run --network tap --ip 10.0.100.22 -d -p 9090:9090 --name kafkaZookeeperWebUI -t tap:zookeeper