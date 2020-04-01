# Stop
docker stop kafkaPython10linesConsumer

# Remove previuos container 
docker container rm kafkaPython10linesConsumer

docker build ../python/ --tag tap:python
docker run --network tap -e PYTHON_APP=tap10linesConsumer.py --name kafkaPython10linesConsumer -it tap:python
