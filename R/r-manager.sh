#!/bin/bash
#ZK_DATA_DIR=/tmp/zookeeper
#ZK_SERVER="localhost"
#[[ -z "${KAFKA_ACTION}" ]] && { echo "KAFKA_ACTION required"; exit 1; }
#[[ -z "${KAFKA_DIR}" ]] && { echo "KAFKA_DIR missing"; exit 1; }
# ACTIONS start-zk, start-kafka, create-topic, 

echo "Running action ${R_ACTION}"
case ${R_ACTION} in
"helloworld")
echo "Starting Hello World"
Rscript hello.R
;;
"tapclassifier")
echo "Classify ${TWEET}"
Rscript classify_opt.R -m ${MODEL} -t "${TWEET}"
;;
"tapconsumer")
echo "Running Tap Consumer"
Rscript classify_consumer.R
;;
esac

