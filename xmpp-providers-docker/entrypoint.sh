#!/bin/sh

set -xeo pipefail

# Generate lists
for list in A B C D As Bs Cs Ds; do
	FETCH_URL="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/master/raw/providers-${list}.json?job=filtered-provider-lists"
	curl -L -o "/var/www/public/providers-${list}.json" "$FETCH_URL"
done

# Sleep 1 hour before refreshing
exec /bin/sleep 3600
