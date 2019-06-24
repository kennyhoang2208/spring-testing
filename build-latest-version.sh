#! bin/bash
set -e

export LAST_VERSION=`cat VERSION`

echo 'latest' > VERSION

# Fetch new tags
git fetch --tags

# Check if the latest existed
if [ ! $(git tag -l vlatest) ]; then
    echo 'Not found. Creating new latest tag.'
    jx step tag --version $(cat VERSION)
else
    echo 'Tag latest existed'
    git tag -f "v$(cat VERSION)"
fi

# Build and push the latest image
gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image "$DOCKER_REGISTRY/$ORG/$APP_NAME:$(cat VERSION)"

# Set the version back to the last one
echo $LAST_VERSION > VERSION
