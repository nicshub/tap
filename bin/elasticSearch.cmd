REM Stop
docker stop elasticsearch

REM Remove previuos container 
docker container rm elasticsearch


#REM Build
docker build ..\elasticsearch\ --tag tap:elasticsearch

docker stop elasticsearch
docker run -p 9200:9200 -p 9300:9300 --ip 10.0.100.51 --network tap -e "discovery.type=single-node"  tap:elasticsearch
