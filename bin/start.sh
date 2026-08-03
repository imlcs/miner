#!/bin/bash
# set -x

params=$1
LOGFILE="amnod.log"


ulimit -c unlimited
ulimit -n 65535
ulimit -s 64000

TIMESTAMP=$(date +%F)
NEW_LOGFILE="logs/${TIMESTAMP}.log" && touch $NEW_LOGFILE

OPTIONS="--data-dir $PWD/data --config-dir $PWD/conf"
# [[ ! -f data/blocks/blocks.index ]] && OPTIONS="$OPTIONS --genesis-json conf/genesis.json"

trap 'echo "[$(date)]Start Shutdown"; kill $(jobs -p); wait; echo "[$(date)]Shutdown ok"' SIGINT SIGTERM

## launch amnod program...
amnod $params $OPTIONS >> $NEW_LOGFILE 2>&1 &
#amnod  $params $OPTIONS --delete-all-blocks >> $NEW_LOGFILE 2>&1 &
#amnod  $params $OPTIONS --hard-replay-blockchain --truncate-at-block 87380000 >> $NEW_LOGFILE 2>&1 &


cd logs && [[ -f "$LOGFILE" ]] && (rm -fr $LOGFILE && ln -s ${TIMESTAMP}.log $LOGFILE) || ln -s ${TIMESTAMP}.log $LOGFILE

wait
