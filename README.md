# panvimdoc

Write documentation in [pandoc markdown](https://pandoc.org/MANUAL.html).
Generate documentation in vimdoc.

# Motivation

Writing documentation is hard.
Decreasing friction when writing documentation is useful.

Writing vim documentation requires conforming to a few simple rules.
`vimdoc` is not a well defined spec but when a text file is in `vimdoc` compatible format and when the `filetype=help` in vim, some nicer syntax highlighting and features are enabled.
Namely, links and tags work well in vim documentation.

See [References](#references) for more information.

It would be nice to write documentation in Markdown and convert to vimdoc.
[@mjlbach](https://github.com/mjlbach) has already implemented a neovim treesitter markdown to vimdoc converter that works fairly well.
I found two other projects that do something similar, again linked in the references.
As far as I can tell, these projects are all in use and actively maintained and these projects may suit your need.

However, none of these projects use Pandoc.
Pandoc Markdown supports a wide number of features.
Firstly, it supports a range of Markdown formats and flavors.
Secondly, Pandoc has lua filters and a custom output writer that can be configured in lua.

This project aims to write a specification in Pandoc Markdown, and take advantage of Pandoc filters, to convert a Markdown file to a vim documentation help file.

# Goals of this project:

- Markdown file must be readable when the file is presented as the README on GitHub / GitLab.
- Markdown file converted to HTML using Pandoc must be web friendly and render appropriately (if the user chooses to do so).
- Vim documentation generated must support links and tags.
- Vim documentation generated should be aesthetically pleasing to view, in vim and as a plain text file.
  - This means using column and spacing appropriately.
- Use built in Vim documentation as guidelines but not rules.

# Features

- Autogenerate title for vim documentation
- Generate links and tags
- Support markdown syntax for tables
- Support raw vimdoc syntax where ever needed for manual control.

# Specification

The specification is described in [panvimdoc.md](./doc/panvimdoc.md) along with examples.
The generated output is in [panvimdoc.txt](./doc/panvimdoc.txt).
The reference implementation of the Pandoc lua filter is in [panvimdoc.lua](./scripts/panvimdoc.lua).

# References

- <https://learnvimscriptthehardway.stevelosh.com/chapters/54.html>
- <https://github.com/nanotee/vimdoc-notes>
- <https://github.com/mjlbach/babelfish.nvim>
- <https://foosoft.net/projects/md2vim/>
- <https://github.com/wincent/docvim>
