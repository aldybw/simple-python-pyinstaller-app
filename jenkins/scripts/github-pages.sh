#!/usr/bin/env sh

set -x
# just to ensure the build
ls build
# set the user, I just use Github Actions. hahaha
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"
# set the target repo
git remote set-url origin https://git:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
# run gh-pages, please ensure the jenkins have the permission
# rm -rf node_modules/gh-pages/.cache
npx gh-pages --message '[skip ci] Updates' --dist build