#! bin/bash
set -e

echo 'latest' > VERSION
if [ ! $(git tag -l vlatest) ]; then
    echo 'Not found. Creating new latest tag.'
    jx step tag --version $(cat VERSION)
else
    echo 'Tag latest existed'
    git tag -f "v$(cat VERSION)"
fi

gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)