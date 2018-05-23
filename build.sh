#!/usr/bin/env bash
set -e

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

if [ "$TRAVIS_BRANCH" == "master" ]; then
    echo "This contains static files, not doing anything"
    exit 0
fi

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This is a pull request, just doing a build"
    bundle exec rake build
    exit 0
fi

if [ "$TRAVIS_BRANCH" != "source" ]; then
    echo "Non source branch, collecting and building but not deploying"
    bundle exec rake collect
    bundle exec rake build
    exit 0
fi

git checkout master || git checkout --orphan master

bundle exec rake collect
bundle exec rake build

# Cleanup
rm -rf _data _includes _layouts _plugins _research _sass
rm -rf _scripts _teaching _assets blog css images pdfs vendor
cp -r ./_site/* ./

git config user.name "CI auto deploy"
git config user.email "nick@schoolph.umass.edu"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key
rm deploy_key # remove secret file

# Commit 
git add .
git commit -m "Auto deploy to GitHub Pages: ${SHA}"

# Push to gh-pages
git push $SSH_REPO master --force
ssh-agent -k
