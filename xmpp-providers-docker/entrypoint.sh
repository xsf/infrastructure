#!/bin/sh

set -xeo pipefail

# Fetch the original providers file.
curl -L -o "/var/www/public/providers.json" "https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/master/raw/providers.json?job=providers-file"

# Fetch the filtered provider lists.
for list in A B C D As Bs Cs Ds; do
	FETCH_URL="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/master/raw/providers-${list}.json?job=filtered-provider-lists"
	curl -L -o "/var/www/public/providers-${list}.json" "$FETCH_URL"
done

# Wait 1 hour before fetching the latest files again.
exec /bin/sleep 3600
