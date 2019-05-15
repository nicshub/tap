REM Stop
docker stop kibana

REM Remove previuos container 
docker container rm kibana

#REM Build
docker build ..\kibana\ --tag tap:kibana

docker stop kibana
docker run -p 5601:5601 --ip 10.0.100.52 --network tap tap:kibana
