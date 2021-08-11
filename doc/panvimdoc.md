---
project: panvimdoc
vimdoctitle: panvimdoc.txt
toc: true
---

# panvimdoc

Write documentation in [pandoc markdown](https://pandoc.org/MANUAL.html).
Generate documentation in vimdoc.

## Codeblocks

```
Multi line Code blocks are indented 4 spaces and

are formatted

appropriately with > and <.
```

Alternatively, you can use `vimdoc` as the language for the code block to write code that will be inserted into the final document.

For example, the following:

````
```vimdoc
You can use codeblocks that have language as `vimdoc` to write raw vimdoc.
```
````

will be rendered as below:

```vimdoc
You can use codeblocks that have language as `vimdoc` to write raw vimdoc.
```

# Title

The first line of the documentation that is generated will look something like this:

```
panvimdoc.txt      For VIM - Vi IMproved 8.1       Last change: 2021 August 11
```

# Heading

Main headings are numbered.

## Sub Heading 2

Sub headings are upper cased heading.

All headings have tags.
You can link to the tags by using [link](#sub-heading-2)

## Mappings

### :[range]CommandName {doc=CommandName}

Command that operates over [range].

### pv{motion}

Command that operates over {motion} moved.

### pvd

Command that takes [count] lines.

### {Visual}pv

Command that operates over highlighted lines.

## Table

<!-- prettier-ignore-start -->
  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax.
<!-- prettier-ignore-end -->
