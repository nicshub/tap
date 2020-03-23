#!/bin/bash
set -v
FLUME_CONF_DIR=/opt/flume/conf
FLUME_AGENT_NAME=a1 

[[ -d "${FLUME_CONF_DIR}"  ]]  || { echo "Flume config dir not mounted in /opt/flume-config";  exit 1; }
[[ -z "${FLUME_AGENT_NAME}" ]] && { echo "FLUME_AGENT_NAME required"; exit 1; }

echo "Starting flume agent : ${FLUME_AGENT_NAME}"

COMMAND="flume-ng agent \
  -c ${FLUME_CONF_DIR} \
  -f ${FLUME_CONF_DIR}/${FLUME_CONF_FILE}\
  -n ${FLUME_AGENT_NAME} \
  -Dflume.root.logger=INFO,console
  -Dorg.apache.flume.log.printconfig=true 
  -Dorg.apache.flume.log.rawdata=true
  "

${COMMAND}
