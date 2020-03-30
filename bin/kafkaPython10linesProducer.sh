# Stop
docker stop kafkaPython10linesProducer

# Remove previuos container 
docker container rm kafkaPython10linesProducer

# docker build ../python/ --tag tap:python
docker run --network tap -e PYTHON_APP=tap10linesProducer.py --name kafkaPython10linesProducer -it tap:python