# Stop
docker stop kafkaCconsumer

# Remove previuos container 
docker container rm kafkaCconsumer

docker build --build-arg topic=$1  ../C-Cpp/ --tag tap:C-Cpp
#consumer of producer defined as an argument
docker run --network tap -e C_APP=CConsumer -e TOPIC=$1 --name kafkaCconsumer -it tap:C-Cpp
