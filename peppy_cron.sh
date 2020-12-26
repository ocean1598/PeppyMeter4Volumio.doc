#!/bin/bash

PEPPY="peppymeter.py"
FIFO="/tmp/myfifo"

echo "Checking if PeppyMeter is already running...."
running=$(ps -ef | grep ${PEPPY} | wc -l);
[[ $running > 1 ]] && exit;

echo "PeppyMeter is not yet running, checking if ${FIFO} exists...."
if [ -p ${FIFO} ]; then
  echo "${FIFO} exits, continue to start PeppyMeter...."
else
  echo "${FIFO} doesn't exist, skip to exit."
  exit 1
fi

echo "Start PeppyMeter...."
cd "${0%/*}"
/bin/openvt -c3 -f /usr/bin/python3 /home/volumio/PeppyMeter/peppymeter.py

