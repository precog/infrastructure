#!/bin/bash

if [[ $# != 2 ]]; then
    echo "Usage: `basename $0` <log config> <kafka config>"
    exit 1
fi

BASEDIR=$(dirname $0)/..

if [ -z "$KAFKA_JMX_OPTS" ]; then
  KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false "
fi
if [ -z "$KAFKA_OPTS" ]; then
  KAFKA_OPTS="-Xmx512M -server -Dlog4j.configuration=file:$1"
fi
if [  $JMX_PORT ]; then
  KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT "
fi

shift 1

/usr/bin/java $KAFKA_OPTS $KAFKA_JMX_OPTS -jar $BASEDIR/lib/kafka-core-assembly-0.7.5.jar $@
