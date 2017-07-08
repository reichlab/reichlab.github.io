# reichlab.github.io

[![Travis](https://img.shields.io/travis/reichlab/reichlab.github.io.svg?style=flat-square)](https://travis-ci.org/reichlab/reichlab.github.io)

Home page source code. Source lies in branch `source`. Github build goes to
`master`.

## Running

1. Install [bundle](https://bundler.io/) and project dependencies

    `bundle install`

2. Add data resources.

3. Collect updates from github repositories mentioned in files.

    `bundle exec rake collect`
    
    > Running this uses unauthenticated requests to Github's API. The limit is
    > 60 per hour. Recommended way is to generate a personal token
    > (https://github.com/settings/tokens) and run collect command as

    `env GH_TOKEN='<token-here>' bundle exec rake collect`

4. Serve/build with jekyll

    ```sh
    bundle exec jekyll serve
    bundle exec jekyll build
    ```
