#!/bin/bash

echo "publishing"

if [[ "$1" != "beta" ]]; then
  sf package version promote --package "$(jq -r .result.SubscriberPackageVersionId .release/version.json)" --no-prompt --json > .release/promote.json
fi

echo "done"
