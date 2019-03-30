#!/bin/bash
set -v
ZK_DATA_DIR=/tmp/zookeeper
ZK_SERVER="localhost"
[[ -z "${KAFKA_ACTION}" ]] && { echo "KAFKA_ACTION required"; exit 1; }
[[ -z "${KAFKA_DIR}" ]] && { echo "KAFKA_DIR missing"; exit 1; }
# ACTIONS start-zk, start-kafka, create-topic, 

echo "Running action ${KAFKA_ACTION} (Kakfa Dir:${KAFKA_DIR}, ZK Server: ${ZK_SERVER})"
case ${KAFKA_ACTION} in
"start-zk")
mkdir -p ${ZK_DATA_DIR}; # Data dir is setup in conf/zookeeper.properties
cd ${KAFKA_DIR}
zookeeper-server-start.sh config/zookeeper.properties
;;
"start-kafka")
mkdir -p ${ZK_DATA_DIR}; # Data dir is setup in conf/zookeeper.properties
cd ${KAFKA_DIR}
zookeeper-server-start.sh config/zookeeper.properties
;;
esac

