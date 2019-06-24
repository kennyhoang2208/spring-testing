#! bin/bash
set -e

# Ensure we're not on a detached head
git checkout master
git config --global credential.helper store
jx step git credentials

# Fetch new tags
git fetch --tags

echo 'latest' > VERSION

# Check if the latest existed
if [ ! $(git tag -l vlatest) ]; then
    echo 'Not found. Creating new latest tag.'

    # jx step tag will format `latest` to `vlatest`
    jx step tag --version $(cat VERSION)
else
    echo 'Tag latest existed'
    git tag -f "vlatest"
fi

# Build and push the latest image
gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image "$DOCKER_REGISTRY/$ORG/$APP_NAME:$(cat VERSION)"
