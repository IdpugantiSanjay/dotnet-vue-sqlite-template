#!/usr/bin/env bash

VERSION=$1

if [[ -n $(git status -s) ]]; then
    echo "Error: git repository is not clean. Please commit or stash your changes."
    exit 1
fi

BRANCH_NAME="changelog-$VERSION"
git checkout -b "$BRANCH_NAME"
git cliff -r . -o CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: update CHANGELOG.md for version $VERSION" --no-verify
git push origin "$BRANCH_NAME" --no-verify