---
project: panvimdoc
vimdoctitle: panvimdoc.txt
toc: true
---

```{.include}
README.md
```

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

```
==============================================================================
2. Heading                                                 *panvimdoc-heading*

Main headings are numbered.
```

## Sub Heading 2

Sub headings are upper cased heading.

```
SUB HEADING 2                                        *panvimdoc-sub-heading-2*

Sub headings are upper cased heading.
```

Notice that both headings and subheadings have tags.

You can link to the tags by using [sub-heading-2](#sub-heading-2).

The following markdown:

```markdown
[sub-heading-2](#sub-heading-2)
```

is converted to the following vimdoc:

## Links

```
You can link to the tags by using |sub-heading-2|
```

This way, any links will work in markdown README on GitHub or on the web using anchors AND will work as tags and links in vimdoc.
The anchors are simply dropped in vimdoc.
The onus is on the documentation writer to write the correct link.

## Mappings

Any markdown header of level 3 is a special header. It can be used to generate documentation of mappings.
All content in curly braces `{...}` is dropped and a tag is created.

The heading `### pv{motion}` becomes the tag `*projectName-pv*`.

Additionally, content in square brackets `[...]` is also dropped for creating the tag name.

The heading `### :[range]Command` becomes the tag `*projectName-:Command*`.

See following headings as examples:

### pv{motion}

Command that operates over {motion} moved.

The following vimdoc mapping is generated:

```
                                                                *projectName-pv*

pv{motion}                             Command that operates over {motion}
                                       moved.

```

### pvd

Command that takes [count] lines.

The following vimdoc mapping is generated:

```
                                                               *projectName-pvd*

pvd                                    Command that takes [count] lines.

```

### :[range]CommandName {doc=CommandName}

Command that operates over [range].

The following vimdoc mapping is generated:

```

                                        *projectName-:CommandName* *CommandName*

:[range]CommandName                    Command that operates over [range].
```

You can use `{doc=AdditionalTag}` to generate one additional tag for each header.

### {Visual}pv

Command that operates over highlighted lines.

The following vimdoc mapping is generated:

```
                                                                *panvimdoc-pv*

{Visual}pv                             Command that operates over highlighted
                                       lines.
```

## Table

Support for markdown tables is also available:

<!-- prettier-ignore-start -->
  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax.

<!-- prettier-ignore-end -->

```
│Right│Left│Center│Default│
│   12│12  │  12  │12     │
│  123│123 │ 123  │123    │
│    1│1   │  1   │1      │
```
