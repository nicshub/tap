REM Stop
docker stop RTap

REM Remove previuos container 
docker container rm RTap

docker build ..\R\ --tag tap:R
docker run --network tap -e R_ACTION=helloworld --name RTap -it tap:R