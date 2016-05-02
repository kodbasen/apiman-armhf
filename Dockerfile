FROM kodbasen/wildfly:10.0.0.Final

ENV APIMAN_VERSION 1.2.5.Final

RUN apk update \
  && apk upgrade \
  && apk add unzip \
  && cd /opt/jboss/wildfly \
  && wget http://downloads.jboss.org/apiman/$APIMAN_VERSION/apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
  && unzip apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
  && rm apiman-distro-wildfly10-$APIMAN_VERSION-overlay.zip \
  && apk del unzip \
  && rm -rf /var/cache/apk/* \
  && mkdir /data

VOLUME /data

COPY run.sh /apiman/run.sh

# Set the default command to run
ENTRYPOINT ["/apiman/run.sh"]
