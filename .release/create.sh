#!/usr/bin/env bash

version="$1"

sf package version create --package "Apex SOQL Builder" --installation-key-bypass --code-coverage --version-number "${version}.NEXT" --version-name "v${version}" --wait 30 --json > .release/version.json