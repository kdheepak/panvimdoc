# panvimdoc

[![Docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://kdheepak.com/panvimdoc/)
[![Build](https://github.com/kdheepak/panvimdoc/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/kdheepak/panvimdoc/actions/workflows/test.yml?query=branch%3Amain)
[![Sponsor](https://img.shields.io/badge/GitHub_Sponsor-%E2%9D%A4-blue)](https://github.com/sponsors/kdheepak)
[![Donate](https://img.shields.io/badge/Donate_Via_Stripe-%E2%9D%A4-blue)](https://donate.stripe.com/8wM9E7bBO9ZsbGUdQR)

Write documentation in [pandoc markdown](https://pandoc.org/MANUAL.html). Generate documentation in
vimdoc.

<img width="1512" alt="image" src="https://github.com/kdheepak/panvimdoc/assets/1813121/dfaed08d-fb9b-4cac-aad0-da71b605265d">

::: center This software is released under a MIT License. :::

# TLDR

1. Choose a name for your project, i.e. `__VIMDOC_PROJECT_NAME_HERE__`. See
   [.github/workflows/panvimdoc.yml](./.github/workflows/panvimdoc.yml) as an example.
2. Add the following to `./.github/workflows/panvimdoc.yml`:

   ```yaml
   name: panvimdoc

   on: [push]

   jobs:
     docs:
       runs-on: ubuntu-latest
       name: pandoc to vimdoc
       steps:
         - uses: actions/checkout@v2
         - uses: kdheepak/panvimdoc@main
           with:
             vimdoc: __VIMDOC_PROJECT_NAME_HERE__
         - uses: stefanzweifel/git-auto-commit-action@v4
           with:
             commit_message: "Auto generate docs"
             branch: ${{ github.head_ref }}
   ```

3. `README.md` gets converted to `./doc/__VIMDOC_PROJECT_NAME_HERE__.txt` and auto-committed to the repo.

# Usage

### Generating vimdoc using GitHub Actions

Create an empty doc file:

```bash
touch doc/.gitkeep
git commit -am "Add empty doc folder"
git push
```

Then add the following to `./.github/workflows/panvimdoc.yml`:

```yaml
name: panvimdoc

on: [push]

jobs:
  docs:
    runs-on: ubuntu-latest
    name: pandoc to vimdoc
    steps:
      - uses: actions/checkout@v2
      - name: panvimdoc
        uses: kdheepak/panvimdoc@main
        with:
          vimdoc: __VIMDOC_PROJECT_NAME_HERE__ # Output vimdoc project name (required)
          # The following are all optional
          pandoc: "README.md" # Input pandoc file
          version: "NVIM v0.8.0" # Vim version number
          toc: true # Table of contents
          description: "" # Project description used in title (if empty, uses neovim version and current date)
          titledatepattern: "%Y %B %d" # Pattern for the date that used in the title
          demojify: false # Strip emojis from the vimdoc
          dedupsubheadings: true # Add heading to subheading anchor links to ensure that subheadings are unique
          treesitter: true # Use treesitter for highlighting codeblocks
          ignorerawblocks: true # Ignore raw html blocks in markdown when converting to vimdoc
          docmapping: false # Use h4 headers as mapping docs
          docmappingprojectname: true # Use project name in tag when writing mapping docs
          shiftheadinglevelby: 0 # Shift heading levels by specified number
          incrementheadinglevelby: 0 # Increment heading levels by specified number
```

The only required thing for you to do is to choose a `__VIMDOC_PROJECT_NAME_HERE__` appropriately. This is
usually the name of the plugin or the documentation file without the `.txt` extension. For example,
the following:

```yaml
- name: panvimdoc
  uses: kdheepak/panvimdoc@main
  with:
    vimdoc: panvimdoc
```

will output a file `doc/panvimdoc.txt` and the vim help tag for it will be `panvimdoc` using the
`main` branch of the repository.

All the other options are optional.

It is recommended to pin to an exact version so you can be confident that no surprises occur for you
or your users. See <https://github.com/kdheepak/panvimdoc/releases/latest> for which version to use.
Once you pick a version, you can pin it like so:

```yaml
- name: panvimdoc
  uses: kdheepak/panvimdoc@vX.X.X
```

For an example of how this is used, see one of the following workflows:

- [kdheepak/panvimdoc](./.github/workflows/panvimdoc.yml): [doc/panvimdoc.txt](./doc/panvimdoc.txt)
- [kdheepak/tabline.nvim](https://github.com/kdheepak/tabline.nvim/blob/main/.github/workflows/ci.yml):
  [doc/tabline.txt](https://github.com/kdheepak/tabline.nvim/blob/main/doc/tabline.txt)

Or see any of the packages here that depend on this action:
<https://github.com/kdheepak/panvimdoc/network/dependents>

### Generating HTML using GitHub Actions

If you are interested in making your vim plugin documentation available as a HTML page, check out
[.github/workflows/docs.yml](./.github/workflows/docs.yml) file. 

You can find the Markdown file you are reading right now converted to HTML here: https://kdheepak.com/panvimdoc/

Here's an example:

```yml
name: docs

on:
  push:
    branches: main

permissions:
  contents: write

jobs:
  publish-gh-page:
    runs-on: ubuntu-latest
    steps:
      - name: checkout code
        uses: actions/checkout@v3
      - name: pandoc markdown to html
        uses: docker://pandoc/latex:3.1
        with:
          args: >-
            --katex --from markdown+tex_math_single_backslash --to html5+smart
            --template="./scripts/template.html5" --css="/panvimdoc/css/theme.css"
            --css="/panvimdoc/css/skylighting-solarized-theme.css" --toc --wrap=none --metadata
            title="panvimdoc" doc/panvimdoc.md --lua-filter=scripts/include-files.lua
            --lua-filter=scripts/skip-blocks.lua -t html -o public/index.html
      - name: deploy to GitHub pages
        uses: JamesIves/github-pages-deploy-action@v4
        with:
          branch: gh-pages
          folder: public
```

### Using pre-commit locally

[pre-commit](https://pre-commit.com/) lets you easily install and manage pre-commit hooks locally.

Two hooks are available, differing only in the way dependencies are handled:

- `panvimdoc-docker`: Requires a running Docker engine on your host. All other dependencies will be loaded inside the container.
- `panvimdoc`: Runs in your local environment, so you have to make sure all dependencies of panvimdoc are installed
    (i.e., `pandoc v3.0.0` or greater)

To use a hook, first install pre-commit. Then, add the following to your `.pre-commit-config.yaml` (here `panvimdoc-docker` is used):

```yaml
- repo: 'https://github.com/kdheepak/panvimdoc'
  rev: v4.0.1
  hooks:
    - id: panvimdoc-docker
      args:
        - '--project-name'
        - <your-project-name>
```

You can specify additional arguments to `panvimdoc.sh` using `args`. See the section below (or run `./panvimdoc.sh`) for the full list of arguments.

To change the input file, modify the `files` field of the hook and supply the corresponding `--input-file` to `args`. In the example below, the hook will be triggered if any `.md` file changes:

```yaml
- repo: 'https://github.com/kdheepak/panvimdoc'
  rev: v4.0.1
  hooks:
    - id: panvimdoc-docker
      files: ^.*\.md$
      args:
        - '--project-name'
        - <your-project-name>
        - '--input-file'
        - <your-input-file.md>
```

### Using it manually locally

The `./panvimdoc.sh` script runs `pandoc` along with all the filters and custom output writer.

```bash
$ ./panvimdoc.sh
Usage: ./panvimdoc.sh --project-name PROJECT_NAME --input-file INPUT_FILE --vim-version VIM_VERSION --toc TOC --description DESCRIPTION --dedup-subheadings DEDUP_SUBHEADINGS --treesitter TREESITTER

Arguments:
  --project-name: the name of the project
  --input-file: the input markdown file
  --vim-version: the version of Vim that the project is compatible with
  --toc: 'true' if the output should include a table of contents, 'false' otherwise
  --description: a project description used in title (if empty, uses neovim version and current date)
  --dedup-subheadings: 'true' if duplicate subheadings should be removed, 'false' otherwise
  --title-date-pattern: '%Y %B %d' a pattern for the date that used in the title
  --demojify: 'false' if emojis should not be removed, 'true' otherwise
  --treesitter: 'true' if the project uses Tree-sitter syntax highlighting, 'false' otherwise
  --ignore-rawblocks: 'true' if the project should ignore HTML raw blocks, 'false' otherwise
  --doc-mapping: 'true' if the project should use h4 headers as mapping docs, 'false' otherwise
  --doc-mapping-project-name: 'true' if tags generated for mapping docs contain project name, 'false' otherwise
  --shift-heading-level-by: 0 if you don't want to shift heading levels , n otherwise
  --increment-heading-level-by: 0 if don't want to increment the starting heading number, n otherwise
```

You will need `pandoc v3.0.0` or greater for this script to work.

# Motivation

Writing user-friendly documentation is important for every successful software project. This is
particularly true when writing documentation for users in the world of vim plugins.

The process of writing and maintaining this documentation can often be a cumbersome, time-consuming
task. This project is aims to make that process a little bit easier by allowing anyone to write
documentation in markdown (or any format Pandoc supports) and converting it to vimdoc automatically.
This way, plugin authors will have to write documentation just once (for example, as part of the
README of the project), and the vim documentation can be autogenerated.

## Rationale

1. **Simplicity**: Writing in Markdown is often more intuitive for developers. By converting from
   Markdown to vimdoc, authors can maintain the simplicity of Markdown while adhering to the vimdoc
   standards.
2. **Unified Documentation**: Plugin authors can write their documentation just once (such as in the
   project's README) and automatically generate vim documentation, ensuring consistency and saving
   time.
3. **Preserving Vim Features**: Vimdoc isn’t just plain text; it supports syntax highlighting, tags,
   links, and careful formatting using whitespace. It's essential to preserve these features when
   converting to ensure the quality and usefulness of the documentation. See
   <https://vimhelp.org/helphelp.txt.html#help-writing> or
   [`@nanotree`'s project](https://github.com/nanotee/vimdoc-notes) for more information.
4. **Leveraging Pandoc**: Unlike existing solutions, this project leverages Pandoc's wide range of
   features, including support for multiple Markdown flavors and easy-to-write custom filters in
   Lua.
5. **Interoperability**: The choice of Pandoc allows for enhanced flexibility, making it easier to
   extend functionality or even adapt the converter for other documentation formats in the future.

## Background

Writing documentation in Markdown and converting it to vimdoc is not a novel idea.

For example, [ibhagwan/ts-vimdoc.nvim](https://github.com/ibhagwan/ts-vimdoc.nvim) is an
implementation a neovim treesitter based markdown to vimdoc converter that works fairly well. There
are no dependencies except for the Markdown treesitter parser. It is neovim only but you can use
this on github actions even for a vim plugin documentation.

There's also [wincent/docvim](https://github.com/wincent/docvim) which is written in Haskell.
Finally there's [FooSoft/md2vim](https://github.com/FooSoft/md2vim) which is written in Go.

None of these projects use Pandoc. Pandoc Markdown supports a wide number of features: See
<https://pandoc.org/MANUAL.html> for more information. Most importantly, it supports a range of
Markdown formats and flavors. And, Pandoc has filters and a custom output writer that can be
configured in lua. Pandoc filters can extend the capability of Pandoc with minimal lua scripting,
and these are very easy to write and maintain too.

That means, with this project, you can write your Vim documentation in Markdown, RestructuredText,
AsciiDoc, etc and convert it to VimDoc, PDF, Word, HTML etc.

# Goals

By offering a specification and reference implementation for converting Pandoc Markdown to vimdoc,
this project aims to reduce friction in the documentation process for vim plugin authors.

Here are the specific goals that guide this project:

- **Readability**: The Markdown files must render correctly when presented as README files on
  platforms like GitHub, GitLab, or SourceHut.
- **Web-Friendly HTML**: If converted to HTML using Pandoc, the Markdown files must be web-friendly
  and render appropriately.
- **VimDoc Features**: The generated vim documentation must support essential features like links
  and tags.
- **Aesthetically Pleasing**: The vim documentation must not only be functional but also visually
  pleasing in both vim and plain text files. This includes the appropriate use of columns and
  spacing.
- **Guidelines**: While the format of built-in Vim documentation is a valuable reference, it is used
  as guidelines rather than strict rules.

# Features

This project offers a comprehensive suite of features designed to streamline the conversion process
from Markdown to vimdoc:

- Automatically generates titles for vim documentation.
- Creates a table of contents to enhance navigation within the document.
- Automatically handles the generation of links and tags.
- Maintains markdown syntax for tables, ensuring proper rendering.
- Allows for manual control through raw vimdoc syntax where necessary.
- Offers the ability to include multiple Markdown files, providing flexibility in documentation
  structure.

# Specification

The specification is described in [panvimdoc.md](./doc/panvimdoc.md) along with examples. The
generated output is in [panvimdoc.txt](./doc/panvimdoc.txt). The reference implementation of the
Pandoc lua filter is in [panvimdoc.lua](./scripts/panvimdoc.lua). See [panvimdoc.sh](./panvimdoc.sh)
for how to use this script, or check the [Usage](#usage) section.

<!-- panvimdoc-ignore-start -->

If you would like to contribute to the specification, or if you have feature requests or opinions,
please feel free to comment here: <https://github.com/kdheepak/panvimdoc/discussions/11>.

<!-- panvimdoc-ignore-end -->

# References

- <https://learnvimscriptthehardway.stevelosh.com/chapters/54.html>
- <https://github.com/nanotee/vimdoc-notes>
- <https://github.com/mjlbach/babelfish.nvim>
- <https://foosoft.net/projects/md2vim/>
- <https://github.com/wincent/docvim>
- <https://github.com/Orange-OpenSource/pandoc-terminal-writer/>

# Donate

If you've found this project helpful, you can show your appreciation by sponsoring me on [GitHub Sponsors](https://github.com/sponsors/kdheepak/) or [donating via Strip](https://donate.stripe.com/8wM9E7bBO9ZsbGUdQR).
