#!/usr/bin/env bash

CIRCLECI_CONFIG=".circleci/config.yml"
DOCKERFILE=Dockerfile

# Read current version from CircleCI config
current_version=`sed -rn 's/^\s*IMAGE_VERSION: \"([0-9\.]*)\"$/\1/p' $CIRCLECI_CONFIG`

# Prompt user for new version
echo "The current configured version of FlexGet: $current_version"
echo "Enter new version:"
read new_version

# Replace version in CircleCI config
sed -i -r "s/(^\s*IMAGE_VERSION: \")([0-9\.]*)\"$/\1$new_version\"/g" $CIRCLECI_CONFIG

# Replace version in Dockerfile
sed -i -r "s/(ARG FLEXGET_VERSION=\")([0-9\.]*)\"$/\1$new_version\"/g" $DOCKERFILE

# Commit version update
git add $CIRCLECI_CONFIG
git commit -m "Bump FlexGet to $new_version"
