# Stop
docker stop kafkaCproducer

# Remove previuos container 
docker container rm kafkaCproducer

docker build --build-arg topic=$1 ../C-Cpp/ --tag tap:C-Cpp
#consumer of producer defined as an argument
docker run --network tap -e C_APP=CProducer -e TOPIC=$1 --name kafkaCproducer -it tap:C-Cpp
