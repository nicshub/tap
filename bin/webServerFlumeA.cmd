REM Stop
docker stop webServerFlumeA
REM Remove previuos container 
docker container rm webServerFlumeA

REM Build
docker build ..\webServerFlume\ --tag tap:webServerFlume

REM Run
docker run --network tap --ip 10.0.100.11 --name "webServerFlumeA" -dit -e FLUME_CONF_FILE=apacheFlume.conf -p 8080:80 tap:webServerFlume