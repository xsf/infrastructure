#!/bin/sh

set -xeo pipefail

base_dir="/var/www/public"

version=1

while true; do
    destination_root="${base_dir}/v${version}"
    source_root="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/stable/v${version}/raw"

    # Check whether there is a file for the desried version.
    http_code=$(curl -o /dev/null -w "%{http_code}" "${source_root}/providers.json?job=providers-file")

    # Quit the loop as soon as there is no file for the desired version anymore.
    [ "${http_code}" -ne 404 ] || break

    mkdir -p ${destination_root}

    # Fetch the original providers file.
    echo "## Fetching v${version} files from ${source_root} to ${destination_root}"
    curl -L -o "${destination_root}/providers.json" "${source_root}/providers.json?job=providers-file"

    # Fetch the filtered provider lists.
    for list in A B C D As Bs Cs Ds; do
	    source="${source_root}/providers-${list}.json?job=filtered-provider-lists"
	    curl -L -o "${destination_root}/providers-${list}.json" "${source}"
    done

    version=$((${version} + 1))
done

# Wait 1 hour before fetching the latest files again.
exec /bin/sleep 3600
