#!/bin/bash -e

FLUENTD_ARGS=$FLUENTD_ARGS
ES_HOST=$ES_HOST
ES_PORT=9200
VARLOG_DIR=/varlog
CONTAINER_DIR=/data/containers

if [ ! -d "$VARLOG_DIR" ]; then
  echo "ERROR: /varlog directory not mounted"
  exit 1
fi

if [ ! -d "$CONTAINER_DIR" ]; then
  echo "ERROR: /data/containers  directory not mounted"
  exit 1
fi

if [ -z "$ES_HOST" ]; then
  echo "ERROR: No ES_HOST env variable defined"
  exit 1
else
  echo "Using ES host: $ES_HOST"
fi
sed -i s/__ES_ENDPOINT_HOST__/$ES_HOST/g /etc/td-agent/td-agent.conf

if [ ! -z "ES_PORT" ]; then
  ES_PORT=$ES_PORT
fi
echo "Using ES port: $ES_PORT"
sed -i s/__ES_ENDPOINT_HOST_PORT__/$ES_PORT/g /etc/td-agent/td-agent.conf

if [ -z "$FLUENTD_ARGS" ]; then
  FLUENTD_ARGS="-c /etc/td-agent/td-agent.conf -qq"
fi
echo "Using config"
cat /etc/td-agent/td-agent.conf

echo "Fluentd args: $FLUENTD_ARGS"

./usr/sbin/td-agent $FLUENTD_ARGS
