#!/usr/bin/env sh

# To make this script work, you should check in the "dist" directory, and configure github pages to run off the
# gh-pages branch.

# Abort on errors
set -e

npm run build

# Check there are no changes

git status --porcelain | grep -q . && { echo "Push your changes and run deploy.sh again."; exit 1; }

echo Changes are committed, we are ok to deploy.

git subtree push --prefix dist origin gh-pages-2
