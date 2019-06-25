#! bin/bash
set -e

# Ensure we're not on a detached head
git checkout master
git config --global credential.helper store
jx step git credentials

# Fetch new tags
git fetch --tags

echo '0.1.0-preview' > VERSION

# Check if the latest existed
if [ ! $(git tag -l v0.1.0-preview) ]; then
    echo 'Not found. Creating new 0.1.0-preview tag.'

    # jx step tag will format `0.1.0-preview` to `v0.1.0-preview`
    jx step tag --version $(cat VERSION)
else
    echo 'The tag 0.1.0-preview existed'
    git tag -f "v0.1.0-preview"
fi

# Build and push the latest image
gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image "$DOCKER_REGISTRY/$ORG/$APP_NAME:$(cat VERSION)"
