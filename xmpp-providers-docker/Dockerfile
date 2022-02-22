FROM debian:buster-slim

ENTRYPOINT ["/usr/bin/tini"]
CMD ["/bin/bash", "/entrypoint.sh"]

ADD entrypoint.sh /entrypoint.sh

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tini curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/*

WORKDIR xmpp-providers
