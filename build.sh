#!/usr/bin/env bash
set -e

# Collect bibtex entries
bundle exec ruby ./_scripts/collect-bibtex.rb
bundle exec jekyll build
# bundle exec htmlproofer ./_site

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "master" ]; then
    echo "Skipping deploy"
    exit 0
fi

cd _site

REPO=git@github.com:reichlab/beta

git config user.name "CI auto deploy"
git config user.email $COMMIT_AUTHOR_EMAIL
git init
git add .
git commit -m "Auto deploy to GitHub Pages: ${SHA}"

git checkout -b gh-pages
git remote add ghp $REPO

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
git push ghp gh-pages --force
