#!/bin/sh

set -xeo pipefail

base_dir="/var/www/public"

version=1

while true; do
    destination_root="${base_dir}/v${version}"
    source_root="https://invent.kde.org/melvo/xmpp-providers/-/jobs/artifacts/stable/v${version}"

    # Check whether there is a file for the desried version (this uses a small file for testing).
    http_code=$(curl -o /dev/null -w "%{http_code}" "${source_root}/raw/providers-As.json?job=filtered-provider-lists")

    # Quit the loop as soon as there is no file for the desired version anymore.
    [ "${http_code}" -ne 404 ] || break

    mkdir -p ${destination_root}

    # Fetch original files.
    if [ "${version}" -eq "1" ]; then
        # The CI job name differs between v1 and v2
        curl -L -o "${destination_root}/providers.json" "${source_root}/raw/providers.json?job=providers-file"
    else
        # The CI job for v2 offers an additional artifact for clients.json.
        for filename in "providers.json" "clients.json"; do
            curl -L -o "${destination_root}/${filename}" "${source_root}/raw/${filename}?job=original-files"
        done
    fi

    # Fetch and extract provider lists and categorization results.
    curl -L -o "${destination_root}/lists-and-results.zip" "${source_root}/download/?job=filtered-provider-lists"
    unzip -o "${destination_root}/lists-and-results.zip" -d "${destination_root}"
    rm "${destination_root}/lists-and-results.zip"

    # Zip all provider lists.
    zip --junk-paths --filesync --recurse-paths "${destination_root}/providers.zip" "${destination_root}" --include "*providers-*.json"

    # Zip all categorization results.
    zip --junk-paths --filesync --recurse-paths "${destination_root}/results.zip" "${destination_root}/results"

    # Fetch and extract badges.
    curl -L -o "${destination_root}/badges.zip" "${source_root}/download/?job=badges"
    unzip -o "${destination_root}/badges.zip" -d "${destination_root}"
    rm "${destination_root}/badges.zip"

    # Zip all provider badges.
    zip --junk-paths --filesync --recurse-paths "${destination_root}/provider-badges.zip" "${destination_root}/badges"

    # Zip all count badges.
    zip --junk-paths --filesync --recurse-paths "${destination_root}/count-badges.zip" "${destination_root}" --include "*count-badge-*.svg"

    version=$((${version} + 1))
done

# Wait 1 hour before fetching the latest files again.
exec /bin/sleep 3600
