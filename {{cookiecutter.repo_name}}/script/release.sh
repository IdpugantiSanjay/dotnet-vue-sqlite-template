#!/usr/bin/env bash

VERSION=$1

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "master" ]]; then
    echo "You are not on the master branch. You are on branch: $CURRENT_BRANCH"
    exit 1
fi

CHANGES=$(git cliff "$(git describe --tags --abbrev=0)"..)
git tag -a "$VERSION" -m "$CHANGES"
git push origin "$VERSION"