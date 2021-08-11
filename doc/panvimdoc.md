---
project: panvimdoc
vimdoctitle: panvimdoc.txt
toc: true
---

# panvimdoc

Write documentation in [pandoc markdown](https://pandoc.org/MANUAL.html).
Generate documentation in vimdoc.

## Sub Heading 2

Sub headings are converted to columns

## Codeblocks

```
Multi line Code blocks are indented 4 spaces and
are formatted appropriately
```

# Heading

Main headings are numbered.
Sub headings are upper cased.

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

Right Left Center Default

---

     12     12        12            12
    123     123       123          123
      1     1          1             1

Table: Demonstration of simple table syntax.
