#!/bin/bash

set -euo pipefail

VERSION=2
UNIQ=""

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed." >&2
    exit 1
fi

generate_packages_json() {
    rpm -qa --queryformat '%{NAME}\t%{VERSION}-%{RELEASE}\n' | \
        sort | \
        jq -Rn '
            [inputs | split("\t") | {(.[0]): .[1]}] | add
        '
}

jq -n \
    --argjson version "$VERSION" \
    --arg uniq "$UNIQ" \
    --argjson packages "$(generate_packages_json)" \
    '{version: $version, uniq: $uniq, packages: $packages}'
