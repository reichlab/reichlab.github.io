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

A short description of the data files follow:

### `publications.yml`

This contains publications that get displayed on the
[/publications](http://reichlab.io/publications) page. A full featured entry for
a publication looks something like the following:

```yaml
title: Title of the publication
doi: >
  [Optional] doi like 10.1371/journal.pone.0035564. This adds the links for
  'Open doi link' and 'Save to mendeley'.
slug: >
  Unique identifier which also maps to a pdf in ./pdfs/publications/<slug>.pdf
  (in case a pdf link is not provided) and an image in
  ./images/publications/<slug>.png
journal: [Optional] Journal name
year: year
volume: [Optional] volume
pages: [Optional] pages
authors: Name of authors (this should be a yaml list but is just a string right now)
keywords: >
  [Optional] Comma separated keywords (this also should be a list but is string
  as of now)
abstract: Abstract
preprint: [Optional] Link to a preprint
pdf: >
  [Optional] Link to pdf. This takes priority over
  ./pdfs/publications/<slug>.pdf
github: [Optional] Github repository identifier like <user>/<repo>
```

### `team.yml`

This contains information about lab members. An entry looks like this:

```yaml
name: Member name
role: Role
description: Blurb
image: >
  A full url to an image (like https://example.com/image.png) or path to local
  image file (like /images/people/foo.png)
# Links is a list of links the member wants to show under his/her description
# In case of no links, put '[]' (empty list) here.
links:
  - name: Link name
    url: Url
  - name: Link 2
    url: Url
type: >
  [Optional] The type of member. This is different than role and is used to
    categorize list of members in sections like 'Alumni'.
```

### `research` and `teaching` sections

Both the [research](http://reichlab.io/research) and
[teaching](http://reichlab.io/teaching) page are organized in terms of sections
or themes which map to a set of markdown files in the directories `_research`
and `_teaching` respectively. Each files contains metadata in its _yaml front
matter_ and the section's summary as its main text. Here is an example markdown
file:

```md
---
title: Section title text
image: /images/research/foo.png # The image for the section
# A list of projects which can either be a github identifier or a dictionary
# with title and description keys
projects:
  - user/repo
  - group/repo
  - title: Project title
    description: Project description
publications: >
  [Optional] Comma separated keywords mapping to that of _data/publications.yml
---
Here goes the section summary.
```
