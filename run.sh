#!/bin/sh

set -e

APIMAN_CONF_FILE="/opt/jboss/wildfly/standalone/configuration/apiman.properties"

APIMAN_ES_HOST=${APIMAN_ES_HOST:-localhost}
APIMAN_ES_PORT=${APIMAN_ES_PORT:-19200}
APIMAN_ES_USERNAME=${APIMAN_ES_USERNAME:-''}
APIMAN_ES_PASSWORD=${APIMAN_ES_PASSWORD:-''}

sed -i -e "s;^apiman.es.host=.*;apiman.es.host=${APIMAN_ES_HOST};" "${APIMAN_CONF_FILE}"
sed -i -e "s;^apiman.es.port=.*;apiman.es.port=${APIMAN_ES_PORT};" "${APIMAN_CONF_FILE}"
sed -i -e "s;^apiman-manager.storage.type=.*;apiman-manager.storage.type=es;" "${APIMAN_CONF_FILE}"
sed -i -e "s;^#apiman-manager.storage.es;apiman-manager.storage.es;" "${APIMAN_CONF_FILE}"
sed -i -e "s;^apiman-manager.storage.es.username=.*;apiman-manager.storage.es.username=${APIMAN_ES_USERNAME};" "${APIMAN_CONF_FILE}"
sed -i -e "s;^apiman-manager.storage.es.password=.*;apiman-manager.storage.es.password=${APIMAN_ES_PASSWORD};" "${APIMAN_CONF_FILE}"
#sed -i -e "s;PollCachingESRegistry;ESRegistry;" "${APIMAN_CONF_FILE}"

DATA_DIR=/data
if test "$(ls -A "$DATA_DIR")"; then
    echo not empty, leaving unmodified
else
    echo The directory $DATA_DIR is empty '(or non-existent)'
    echo Copying default data for first run
    cp -r /opt/jboss/wildfly/standalone/data/* /data
fi

/opt/jboss/wildfly/bin/standalone.sh -Djboss.server.data.dir=/data -b 0.0.0.0 -bmanagement 0.0.0.0 -c standalone-apiman.xml
