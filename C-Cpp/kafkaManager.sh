#!/bin/bash
[[ -z "${C_APP}" ]] && { echo "C_APP required"; exit 1; }
C_DIR="/usr/src/CkafkaManager/"
BROKERID=1

echo "Running C ${C_APP} (C Dir:${C_DIR})"
cd ${C_DIR}
if [[ "${C_APP}" = "CProducer" ]]
then
    ./${C_APP} 10.0.100.23 $TOPIC
else
    ./${C_APP} 10.0.100.23 $BROKERID $TOPIC
fi

