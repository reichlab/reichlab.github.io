#!/usr/bin/env bash

# make sure error stop script
set -e

# Save some useful information
HEAD_HASH=`git rev-parse --verify HEAD` # latest commit hash
HEAD_HASH=${HEAD_HASH: -7} # get the last 7 characters of hash

# install system dependencies
sudo apt install ruby ruby-dev gem

# install bundler
sudo gem install bundler

# install packages
bundle install

# collect and build
bundle exec rake collect
bundle exec rake build

if [ "$CI" = true ]; then
  git config user.name "GitHub Action"
  git config user.email "user@example.com"
fi

git add -A
git commit -m "Auto deploy commit ${HEAD_HASH} to GitHub Pages at ${date}"
git subtree push --prefix _site origin gh-pages
git push origin source
