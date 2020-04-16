# Get the GCC preinstalled image from Docker Hub
FROM gcc:4.9
MAINTAINER Giorgio Locicero
ARG topic="pippo"
#ARG comando="./kafkaManager ${topic}"

# Copy the current folder which contains C++ source code to the Docker image under /usr/src
COPY /conf /usr/src/CkafkaManager

# Specify the working directory
WORKDIR /usr/src/CkafkaManager

#update repo and download libraries for kafka
RUN apt-get update -y && apt-get install -y apt-transport-https
RUN wget -qO - https://packages.confluent.io/deb/5.4/archive.key | apt-key add - && apt-get install -y software-properties-common && add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/5.4 stable main" && apt-get update -y && apt-get install -y librdkafka-dev

# Use make and GCC to compile the Test.cpp source file
RUN make

COPY kafkaManager.sh kafkaManager

RUN chmod a+x kafkaManager

# Run the program that handles the creation of a producer or consumer
#CMD ["sh", "-c","./kafkaManager $topic"]
CMD ["./kafkaManager"]
#CMD ["bash"]