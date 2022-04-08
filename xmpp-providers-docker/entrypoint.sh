#!/bin/sh

set -xeo pipefail

# Generate lists
for list in A B C D; do
	FETCH_URL="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/master/raw/providers-${list}.json?job=filtered-provider-lists"
	curl -L -o "/var/www/public/providers-${list}.json" "$FETCH_URL"
done

# Sleep ~24 hours
exec /bin/sleep 86400
