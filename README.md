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

## Developing

Overall, the source code follows the usual [jekyll](http://jekyllrb.com/)
structure. We use a few additional custom scripts/plugins to work with data
files like `_data/team.yml`. This section documents the peripheral tooling
involved.

## 1. Plugins

Plugins in `./_plugins` read in the data from `./_data`, `./_research` and
`./_teaching` and provide them as variables in the corresponding pages (like
`./teaching.html` for `_teaching`).

Since the plugin and html file for research and teaching look very similar, we
generate both of them from a single source file using
[ribosome](https://github.com/sustrik/ribosome). We call these pages (research
and teaching) _thematic_ pages. The ruby plugin file is generated from
`./_scripts/theme-gen-gen.rb.dna` and the html file from
`./_scripts/theme-page.html.dna`. The process is scripted in the rakefile and is
described in the next section.

## 2. Rake tasks

We use [rake](https://github.com/ruby/rake) for specifying and running tasks..
The main tasks are `collect` and `build`.

### `collect`
Before building the website, we need to collect some metadata (last commit
information etc.) about github repositories listed in the files
`./_research/*.md` and `./_teaching/*.md`. This involves using the github api
and running the script `./_scripts/collect-repos.rb`. The following command runs
this task and produces an updated `._data/repositories.yml` file with all the
metadata required:

```sh
bundle exec rake collect
```

Since github api has limits, we need to pass [a
token](https://github.com/settings/tokens) so that the task can finish
successfully:

```sh
env GH_TOKEN='<token-here>' bundle exec rake collect
```

### `build`
This is the main build task which just wraps around jekyll's own build.

```sh
bundle exec rake build
```

### `tpgen`

This task generates a thematic page template (the html file). It needs two extra
arguments,

1. The name of the theme page (like 'research' or 'teaching')
2. Short text (divider text) which goes over the list of projects (like 'LINKS'
   in teaching and 'PROJECTS' in research)

The command below will produce a page `./teaching.html` with a divider text
'ITEMS'.

```sh
bundle exec rake tpen[teaching,items]
```

### `ggen`

This produces a ruby plugin for corresponding (html of the same name) thematic
page. It needs one extra argument which is the name of the theme page.

The command below produces a plugin `./_plugins/teaching.rb` and works with the
template page `./teaching.html` using data from `_/teaching` directory.

```sh
bundle exec rake ggen[teaching]
```

## 3. Travis

We use travis to run the website build process every time commits are pushed on
github. Travis also rebuilds the website each night so that the information
collected about the github repositories stays fresh.

The main file for travis is `./build.sh` which checks for a few things (like
which branch are we building for) and runs the rake tasks `collect` and `build`.
Once done, it pushes the generated static html files to the repository's master
branch. For pushing, it needs an authentication key which is kept encrypted in
the file `./deploy_key.enc`.
