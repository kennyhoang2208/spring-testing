#! bin/bash
set -e

# Ensure we're not on a detached head
git checkout master
git config --global credential.helper store
jx step git credentials

# Fetch new tags
git fetch --tags

echo '0.1.0-SNAPSHOT' > VERSION

# Check if the latest existed
if [ $(git tag -l v0.1.0-SNAPSHOT) ]; then
    echo 'The tag 0.1.0-SNAPSHOT existed'
    # Delete the tag
    git tag -d "v0.1.0-SNAPSHOT"
    git push --delete origin "v0.1.0-SNAPSHOT"
fi

# jx step tag will format `0.1.0-SNAPSHOT` to `v0.1.0-SNAPSHOT`
jx step tag --version $(cat VERSION)

# Build and push the latest image
gradle clean build
export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml
jx step post build --image "$DOCKER_REGISTRY/$ORG/$APP_NAME:$(cat VERSION)"
