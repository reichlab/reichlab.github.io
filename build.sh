#!/usr/bin/env bash

# make sure error stop script
set -e

# Save some useful information
REPO=`git config remote.origin.url` # repo URL (https)
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:} # repo URL (ssh)
HEAD_HASH=`git rev-parse --verify HEAD` # latest commit hash
HEAD_HASH=${HEAD_HASH: -7} # get the last 7 characters of hash

# install system dependencies
sudo apt install ruby ruby-dev gem

# install bundler
gem install bundler

# install packages
bundle install

# collect and build
bundle exec rake collect
bundle exec rake build

# Cleanup
rm -rf _data _includes _layouts _plugins _research _sass
rm -rf _scripts _teaching _assets blog css images pdfs vendor
cp -r ./_site/* ./

git checkout master || git checkout --orphan master

if [ "$ENV" = "CI" ]; then
  git config user.name "GitHub Action"
  git config user.email "user@example.com"
fi

#git config user.name "CI auto deploy"
#git config user.email "nick@schoolph.umass.edu"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
#chmod 600 deploy_key
#eval `ssh-agent -s`
#ssh-add deploy_key
#rm deploy_key # remove secret file

# Commit 
git add -A
git commit -m "Auto deploy commit ${HEAD_HASH} to GitHub Pages at ${date}"

# Push to gh-pages
git push $SSH_REPO master --force
