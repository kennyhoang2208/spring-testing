#! bin/bash
set -e

# Check if the tag 0.1.0-SNAPSHOT existed
if [ $(git tag -l v0.1.0-SNAPSHOT) ]; then
    echo 'The tag 0.1.0-SNAPSHOT existed'
    # Delete the tag
    git tag -d "v0.1.0-SNAPSHOT"
    git push --delete origin "v0.1.0-SNAPSHOT"
fi
