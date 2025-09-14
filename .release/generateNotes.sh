export PACKAGE_ID=$(cat .release/version.json | jq -r .result.SubscriberPackageVersionId)

cat .release/notesTemplate.md | envsubst
