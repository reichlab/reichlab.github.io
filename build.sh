#!/usr/bin/env bash
set -e

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

git checkout master || git checkout --orphan master

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "source" ]; then
    echo "Skipping deploy"
    exit 0
fi

# Collect data
bundle exec rake collect
bundle exec rake build
# bundle exec rake test

# Cleanup
rm -rf _data _includes _layouts _plugins _research _sass
rm -rf _scripts _teaching _assets blog css images pdfs vendor
cp -r ./_site/* ./

git config user.name "CI auto deploy"
git config user.email "nick@schoolph.umass.edu"

git add .
git commit -m "Auto deploy to GitHub Pages: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key

# Push to gh-pages
git push $SSH_REPO master --force
ssh-agent -k
