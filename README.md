# reichlab.github.io

[![Travis](https://img.shields.io/travis/reichlab/reichlab.github.io.svg?style=flat-square)](https://travis-ci.org/reichlab/reichlab.github.io)

Home page source code. Source lies in branch `source`. Github build goes to
`master`.

## Building

1. Install [bundle](https://bundler.io/) and project dependencies

    `bundle install`

2. Add content. See [here](#contributing--adding-content) for details.

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

## Contributing / adding content

The website uses jekyll and most of the pages get their content directly using
the markdown/html template, except a few pages for which the data source is a
kept in separate files and then is injected to the template via plugins kept in
`_plugins`.

- Team members data go in `_data/team.yml`
- Publications go in `_data/publications.yml`
- New sections for 'research' and 'teaching' page go in `_research` and
  `_teaching` directory respectively.

Pull requests should go to `source` branch (not master) since travis builds the
website from there.
