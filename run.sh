#!/bin/bash -e

FLUENTD_ARGS=$FLUENTD_ARGS
ES_HOST=$ES_HOST
ES_PORT=$ES_PORT

if [ -z "$ES_HOST" ]; then
  echo "ERROR: No ES_HOST env variable defined"
  exit 1
else
  echo "Using ES host: $ES_HOST"
fi
sed -i s/__ES_ENDPOINT_HOST__/$ES_HOST/g /etc/td-agent/td-agent.conf

if [ -z "ES_PORT" ]; then
  echo "Using default ES port: 9200"
  ES_PORT=9200
else
  echo "Using ES port: $ES_PORT"
fi
sed -i s/__ES_ENDPOINT_PORT__/$ES_PORT/g /etc/td-agent/td-agent.conf

if [ -z "$FLUENTD_ARGS" ]; then
  FLUENTD_ARGS="-c /etc/td-agent/td-agent.conf -qq"
fi
echo "Fluentd args: $FLUENTD_ARGS"

/bin/bash /usr/sbin/td-agent $FLUENTD_ARGS > /var/log/td-agent/td-agent.log
