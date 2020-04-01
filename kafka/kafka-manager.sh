#!/bin/bash
ZK_DATA_DIR=/tmp/zookeeper
ZK_SERVER="localhost"
[[ -z "${KAFKA_ACTION}" ]] && { echo "KAFKA_ACTION required"; exit 1; }
[[ -z "${KAFKA_DIR}" ]] && { echo "KAFKA_DIR missing"; exit 1; }
# ACTIONS start-zk, start-kafka, create-topic, 

echo "Running action ${KAFKA_ACTION} (Kakfa Dir:${KAFKA_DIR}, ZK Server: ${ZK_SERVER})"
case ${KAFKA_ACTION} in
"start-zk")
echo "Starting ZK"
mkdir -p ${ZK_DATA_DIR}; # Data dir is setup in conf/zookeeper.properties
cd ${KAFKA_DIR}
zookeeper-server-start.sh config/zookeeper.properties
;;
"start-kafka")
cd ${KAFKA_DIR}
kafka-server-start.sh config/server.properties
;;
"create-topic")
cd ${KAFKA_DIR}
kafka-topics.sh --create --zookeeper 10.0.100.22:2181 --replication-factor 1 --partitions 1 --topic ${KAFKA_TOPIC}
;;
"producer")
cd ${KAFKA_DIR}
#bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
kafka-console-producer.sh --broker-list 10.0.100.23:9092 --topic ${KAFKA_TOPIC}
;;
"consumer")
cd ${KAFKA_DIR}
kafka-console-consumer.sh --bootstrap-server 10.0.100.23:9092 --topic ${KAFKA_TOPIC} --from-beginning ${KAFKA_CONSUMER_PROPERTIES}
;;
"connect-standalone")
cd ${KAFKA_DIR}
#connect-standalone-twitter.properties mysqlSinkTwitter.conf
touch /tmp/my-test.txt
bin/connect-standalone.sh config/${KAFKA_WORKER_PROPERTIES} config/${KAFKA_CONNECTOR_PROPERTIES}  
;;
"run-class")
cd ${KAFKA_DIR}
bin/kafka-run-class.sh ${KAFKA_CLASS} --bootstrap-server 10.0.100.23:9092 --zookeeper 10.0.100.22:2181 --broker-list 10.0.100.23:9092 
;;
esac

