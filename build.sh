#!/usr/bin/env bash

set -e

# Collect bibtex entries
bundle exec ruby ./_scripts/collect-bibtex.rb

bundle exec jekyll build
bundle exec htmlproofer ./_site
