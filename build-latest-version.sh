#! bin/bash
set -e

echo 'latest' > VERSION
if [ ! $(git tag -l vlatest) ]; then
    jx step tag --version $(cat VERSION)
else
    git tag -f $(cat VERSION)
fi

gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)