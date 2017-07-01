# reichlab.github.io

[![Travis](https://img.shields.io/travis/reichlab/beta.svg?style=flat-square)](https://travis-ci.org/reichlab/beta)

Home page source code.

## Running

1. Install [bundle](https://bundler.io/) and project dependencies

    `bundle install`

2. Add data resources.

3. Collect udates from github repositories mentioned in files.

    `bundle exec rake collect`

4. Serve/build with jekyll

    ```sh
    bundle exec jekyll serve
    bundle exec jekyll build
    ```
