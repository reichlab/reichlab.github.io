#!/usr/bin/env bash

# make sure error stop script
set -e

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
HEAD_HASH=`git rev-parse --verify HEAD` # latest commit hash
HEAD_HASH=${HEAD_HASH: -7} # get the last 7 characters of hash

# install system dependencies
sudo apt install ruby ruby-dev gem

# install bundler
sudo gem install bundler

# install packages
bundle install

# remove old site
rm -rf ./_site

if [ "$CI" = true ]; then
  git config user.name "GitHub Action"
  git config user.email "user@example.com"
fi

git checkout gh-pages
git checkout source
git worktree add _site gh-pages

# collect and build
bundle exec rake collect
bundle exec rake build
(cd _site; git add .)
(cd _site; git commit -am "Auto deploy commit ${HEAD_HASH} to GitHub Pages at ${date}")
git push origin gh-pages
