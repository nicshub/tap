#!/bin/bash
set -v
echo "Running ZkUI"
zkServer.sh start
cd /opt/zkui/
java -jar /opt/zkui/zkui-* 


