#!/bin/bash
set -e

# Check if the tag 0.1.0-preview existed
if [ $(git tag -l v0.1.0-preview) ]; then
    echo 'The tag 0.1.0-preview existed'
    # Delete the tag
    git tag -d "v0.1.0-preview"
    git push --delete origin "v0.1.0-preview"
fi
