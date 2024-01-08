#!/bin/sh

set -xeo pipefail

base_dir="/var/www/public"

version=1

while true; do
    destination_root="${base_dir}/v${version}"
    source_root="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/stable/v${version}"

    # Check whether there is a file for the desried version.
    http_code=$(curl -o /dev/null -w "%{http_code}" "${source_root}/download/?job=badges")

    # Quit the loop as soon as there is no file for the desired version anymore.
    [ "${http_code}" -ne 404 ] || break

    mkdir -p ${destination_root}

    # Fetch original files.
    if [ "${version}" -eq "1" ]; then
        curl -L -o "${destination_root}/providers.json" "${source_root}/raw/providers.json?job=providers-file"
    else
        for filename in "providers.json" "clients.json"; do
            curl -L -o "${destination_root}/${filename}" "${source_root}/raw/${filename}?job=original-files"
        done
    fi

    # Fetch the filtered provider lists.
    for list in A B C D As Bs Cs Ds; do
        curl -L -o "${destination_root}/providers-${list}.json" "${source_root}/raw/providers-${list}.json?job=filtered-provider-lists"
    done

    # Fetch filtered provider lists archive.
    curl -L -o "${destination_root}/filtered-provider-lists.zip" "${source_root}/download/?job=filtered-provider-lists"

    # Fetch badges archive.
    curl -L -o "${destination_root}/badges.zip" "${source_root}/download/?job=badges"

    version=$((${version} + 1))
done

# Wait 1 hour before fetching the latest files again.
exec /bin/sleep 3600
