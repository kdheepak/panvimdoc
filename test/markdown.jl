@testset "markdown" begin
  doc = test_pandoc(
    raw"""
# panvimdoc

<div align="center">
  <img src="https://user-images.githubusercontent.com/292349/213446185-2db63fd5-8c84-459c-9f04-e286382d6e80.png">
</div>

<hr>

<div align="center"><p>
    <a href="https://github.com/LazyVim/LazyVim/releases/latest">
      <img alt="Latest release" src="https://img.shields.io/github/v/release/LazyVim/LazyVim?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41&include_prerelease&sort=semver" />
    </a>
</div>

"Double quoted string"

> Testing block quote

| testing line
| block

![caption](image.png)

% Title
  spanning multiple lines
% Author One
  Author Two; Author Three;
  Author Four

# Additional markdown reader tests

## Blank line before URL in link reference

[foo] and [bar]

[foo]:
  /url

[bar]:
/url
"title"

## Raw ConTeXt environments

\placeformula \startformula
   L_{1} = L_{2}
   \stopformula

\start[a2]
\start[a2]
\stop[a2]
\stop[a2]

## Raw LaTeX environments

\begin{center}
\begin{tikzpicture}[baseline={([yshift=+-.5ex]current bounding box.center)}, level distance=24pt]
\Tree [.{S} [.NP John\index{i} ] [.VP [.V likes ] [.NP himself\index{i,*j} ]]]
\end{tikzpicture}
\end{center}

## URLs with spaces and punctuation

[foo](/bar and baz)
[foo](/bar
 and baz )
[foo]( /bar  and  baz  )
[foo](bar baz  "title" )

[baz][] [bam][] [bork][]

[baz]: /foo foo
[bam]:  /foo fee
[bork]:  /foo/zee zob   (title)

[Ward's method.](http://en.wikipedia.org/wiki/Ward's_method)

## Horizontal rules with spaces at end

* * * * *

-- - -- -- -

## Raw HTML before header

<a></a>

### my header

## $ in math

$\$2 + \$3$

$x = \text{the $n$th root of $y$}$

This should not be math:

$PATH 90 $PATH

## Commented-out list item

- one
<!--
- two
-->
- three

## Indented code at beginning of list

-     code
      code

  1.     code
         code

  12345678.     code
                code

  -     code
        code

  -    no code

## Backslash newline

hi\
there

## Code spans

`hi\`

`hi
there`

`` hi````there ``

`hi

there`

## helptags

This content includes a helptag for `:h :a-complex.messy-%tag` inbetween other text.

## Multilingual URLs

<http://测.com?测=测>

[foo](/bar/测?x=测 "title")

<测@foo.测.baz>

## Numbered examples

(@) First example.
(@foo) Second example.

Explanation of examples (@foo) and (@bar).

(@bar) Third example.

## Macros

\newcommand{\tuple}[1]{\langle #1 \rangle}

$\tuple{x,y}$

## Case-insensitive references

[Fum]

[FUM]

[bat]

[fum]: /fum
[BAT]: /bat

## Curly smart quotes

“Hi”

‘Hi’

## Consecutive lists

- one
- two
1. one
2. two

 a. one
 b. two

## Implicit header references

### My header

### My other header

A link to [My header].

Another link to [it][My header].

Should be [case insensitive][my header].

Link to [Explicit header attributes].

[my other header]: /foo

But this is not a link to [My other header], since the reference is defined.

## Explicit header attributes {#foobar .baz key="val"}

> ## Header attributes inside block quote {#foobar .baz key="val"}

## Line blocks

| But can a bee be said to be
|     or not to be an entire bee,
|         when half the bee is not a bee,
|             due to some ancient injury?
|
| Continuation
 line
|   and
       another

## Grid Tables

+------------------+-----------+------------+
| col 1            | col 2     | col 3      |
+==================+===========+============+
| r1 a             | b         | c          |
| r1 bis           | b 2       | c 2        |
+------------------+-----------+------------+
| r2 d             | e         | f          |
+------------------+-----------+------------+

Headless

+------------------+-----------+------------+
| r1 a             | b         | c          |
| r1 bis           | b 2       | c 2        |
+------------------+-----------+------------+
| r2 d             | e         | f          |
+------------------+-----------+------------+

With alignments

+------------------+-----------+------------+
| col 1            | col 2     | col 3      |
+=================:+:==========+:==========:+
| r1 a             | b         | c          |
| r1 bis           | b 2       | c 2        |
+------------------+-----------+------------+
| r2 d             | e         | f          |
+------------------+-----------+------------+

Headless with alignments

+-----------------:+:----------+:----------:+
| r1 a             | b         | c          |
| r1 bis           | b 2       | c 2        |
+------------------+-----------+------------+
| r2 d             | e         | f          |
+------------------+-----------+------------+

Spaces at ends of lines

+------------------+-----------+------------+
| r1 a             | b         | c          |
| r1 bis           | b 2       | c 2        |
+------------------+-----------+------------+
| r2 d             | e         | f          |
+------------------+-----------+------------+

Multiple blocks in a cell

+------------------+-----------+------------+
| # col 1          | # col 2   | # col 3    |
| col 1            | col 2     | col 3      |
+------------------+-----------+------------+
| r1 a             | - b       | c          |
|                  | - b 2     | c 2        |
| r1 bis           | - b 2     | c 2        |
+------------------+-----------+------------+

East Asian characters have double width

+--+----+
|魚|fish|
+--+----+

Zero-width space in German

+-------+-------+
|German |English|
+-------+-------+
|Auf‌lage|edition|
+-------+-------+

Zero-width non-joiner in Persian

+-------+---------+
|می‌خواهم|I want to|
+-------+---------+

Empty cells

+---+---+
|   |   |
+---+---+


Table with cells spanning multiple rows or columns:

+---------------------+----------+
| Property            | Earth    |
+=============+=======+==========+
|             | min   | -89.2 °C |
| Temperature +-------+----------+
| 1961-1990   | mean  | 14 °C    |
|             +-------+----------+
|             | min   | 56.7 °C  |
+-------------+-------+----------+

Table with complex header:

+---------------------+-----------------------+
| Location            | Temperature 1961-1990 |
|                     | in degree Celsius     |
|                     +-------+-------+-------+
|                     | min   | mean  | max   |
+=====================+=======+=======+=======+
| Antarctica          | -89.2 | N/A   | 19.8  |
+---------------------+-------+-------+-------+
| Earth               | -89.2 | 14    | 56.7  |
+---------------------+-------+-------+-------+

## Entities in links and titles

[link](/&uuml;rl "&ouml;&ouml;!")

<http://g&ouml;&ouml;gle.com>

<me@ex&auml;mple.com>

[foobar]

[foobar]: /&uuml;rl "&ouml;&ouml;!"

## Parentheses in URLs

[link](/hi(there))

[link](/hithere\))

[linky]

[linky]: hi_(there_(nested))

## Backslashes in link references

[\*\a](b)

## Reference link fallbacks

[*not a link*] [*nope*]...

## Reference link followed by a citation

MapReduce is a paradigm popularized by [Google] [@mapreduce] as its
most vocal proponent.

[Google]: http://google.com

## Empty reference links

[foo2]:

bar

[foo2]

## Wrapping

- blah blah blah blah blah blah blah blah blah blah blah blah blah blah 2015.

## Bracketed spans

[*foo* bar baz [link](url)]{.class #id key=val}

## panvimdoc-include-comment-content

<!-- panvimdoc-include-comment-content Neovim is a great text editor. -->

<!-- panvimdoc-include-comment-content

Neovim supports `:h lua` plugins and is also:

- Multiplatform
- Open source

## All Content Types

### Are supported

See [neovim.org](https://neovim.org).

-->

    """;
    toc = false,
    demojify = true,
  )
  @test raw"""
*test.txt*                                                    Test Description

==============================================================================
1. panvimdoc                                                  *test-panvimdoc*




"Double quoted string"


  Testing block quote

| testing line
| block
% Title spanning multiple lines % Author One Author Two; Author Three; Author
Four


==============================================================================
2. Additional markdown reader tests    *test-additional-markdown-reader-tests*


BLANK LINE BEFORE URL IN LINK REFERENCE*test-blank-line-before-url-in-link-reference*

foo </url> and bar </url>


RAW CONTEXT ENVIRONMENTS                       *test-raw-context-environments*

L_{1} = L_{2}


RAW LATEX ENVIRONMENTS                           *test-raw-latex-environments*


URLS WITH SPACES AND PUNCTUATION       *test-urls-with-spaces-and-punctuation*

foo </bar%20and%20baz> foo </bar%20and%20baz> foo </bar%20and%20baz> foo
<bar%20baz>

baz </foo%20foo> bam </foo%20fee> bork </foo/zee%20zob>

Ward’s method. <http://en.wikipedia.org/wiki/Ward's_method>


HORIZONTAL RULES WITH SPACES AT END *test-horizontal-rules-with-spaces-at-end*

------------------------------------------------------------------------------
------------------------------------------------------------------------------

RAW HTML BEFORE HEADER                           *test-raw-html-before-header*




MY HEADER ~


$ IN MATH                                                     *test-$-in-math*

`\$2 + \$3`

`x = \text{the $n$th root of $y$}`

This should not be math:

$PATH 90 $PATH


COMMENTED-OUT LIST ITEM                         *test-commented-out-list-item*

- one
- three


INDENTED CODE AT BEGINNING OF LIST   *test-indented-code-at-beginning-of-list*

- >
        code
        code
    <
    1. >
        code
        code
    <
    2. >
        code
        code
    <
    - >
            code
            code
        <
    - no code


BACKSLASH NEWLINE                                     *test-backslash-newline*

hi there


CODE SPANS                                                   *test-code-spans*

`hi\`

`hi there`

`hi````there`

`hi

there`


HELPTAGS                                                       *test-helptags*

This content includes a helptag for |:a-complex.messy-%tag| inbetween other
text.


MULTILINGUAL URLS                                     *test-multilingual-urls*

<http://.com?=>

foo </bar/测?x=测>

@foo..baz <mailto:测@foo.测.baz>


NUMBERED EXAMPLES                                     *test-numbered-examples*

1. First example.
2. Second example.

Explanation of examples (2) and (3).

1. Third example.


MACROS                                                           *test-macros*

`\langle x,y \rangle`


CASE-INSENSITIVE REFERENCES                 *test-case-insensitive-references*

Fum </fum>

FUM </fum>

bat </bat>


CURLY SMART QUOTES                                   *test-curly-smart-quotes*

"Hi"

'Hi'


CONSECUTIVE LISTS                                     *test-consecutive-lists*

- one
- two

1. one
2. two

1. one
2. two


IMPLICIT HEADER REFERENCES                   *test-implicit-header-references*


MY HEADER ~


MY OTHER HEADER ~

A link to |test-my-header|.

Another link to |test-it|.

Should be |test-case-insensitive|.

Link to |test-explicit-header-attributes|.

But this is not a link to My other header </foo>, since the reference is
defined.


EXPLICIT HEADER ATTRIBUTES                   *test-explicit-header-attributes*


  HEADER ATTRIBUTES INSIDE BLOCK QUOTE*test-header-attributes-inside-block-quote*

LINE BLOCKS                                                 *test-line-blocks*


| But can a bee be said to be
|     or not to be an entire bee,
|         when half the bee is not a bee,
|             due to some ancient injury?
|
| Continuation line
|   and another

GRID TABLES                                                 *test-grid-tables*

  -------------------------------------------
  col 1              col 2       col 3
  ------------------ ----------- ------------
  r1 a r1 bis        b b 2       c c 2

  r2 d               e           f
  -------------------------------------------
Headless

  ------------------ ----------- ------------
  r1 a r1 bis        b b 2       c c 2

  r2 d               e           f
  ------------------ ----------- ------------
With alignments

  -------------------------------------------
               col 1 col 2          col 3
  ------------------ ----------- ------------
         r1 a r1 bis b b 2          c c 2

                r2 d e                f
  -------------------------------------------
Headless with alignments

  ------------------ ----------- ------------
         r1 a r1 bis b b 2          c c 2

                r2 d e                f
  ------------------ ----------- ------------
Spaces at ends of lines

  ------------------ ----------- ------------
  r1 a r1 bis        b b 2       c c 2

  r2 d               e           f
  ------------------ ----------- ------------
Multiple blocks in a cell

+------------------+-----------+------------+
| col 1            | col 2     | col 3      |
|                  |           |            |
| col 1            | col 2     | col 3      |
+------------------+-----------+------------+
| r1 a             | -   b     | c c 2 c 2  |
|                  | -   b 2   |            |
| r1 bis           | -   b 2   |            |
+------------------+-----------+------------+
East Asian characters have double width

  -- ------
     fish

  -- ------
Zero-widthspace in German

  --------- ---------
  German    English

  Auf‌lage   edition
  --------- ---------
Zero-width non-joiner in Persian

  --------- ---------
  می‌خواهم   I want to

  --------- ---------
Empty cells

  --- ---


  --- ---
Table with cells spanning multiple rows or columns:

  --------------------------------
  Property              Earth
  ------------- ------- ----------
  Temperature   min     -89.2 °C
  1961-1990

                mean    14 °C

                min     56.7 °C
  --------------------------------
Table with complex header:

  ---------------------------------------------------
  Location              Temperature
                        1961-1990 in
                        degree
                        Celsius
  --------------------- ------------- ------- -------
                        min           mean    max

  Antarctica            -89.2         N/A     19.8

  Earth                 -89.2         14      56.7
  ---------------------------------------------------

ENTITIES IN LINKS AND TITLES               *test-entities-in-links-and-titles*

link </ürl>

<http://göögle.com>

me@exämple.com <mailto:me@exämple.com>

foobar </ürl>


PARENTHESES IN URLS                                 *test-parentheses-in-urls*

link </hi(there)>

link </hithere)>

linky <hi_(there_(nested))>


BACKSLASHES IN LINK REFERENCES           *test-backslashes-in-link-references*

<b>


REFERENCELINK FALLBACKS                         *test-referencelink-fallbacks*

[_not a link_] [_nope_]…


REFERENCE LINK FOLLOWED BY A CITATION*test-reference-link-followed-by-a-citation*

MapReduce is a paradigm popularized by Google <http://google.com>
(**mapreduce?**) as its most vocal proponent.


EMPTY REFERENCE LINKS                             *test-empty-reference-links*

bar

foo2 <>


WRAPPING                                                       *test-wrapping*

- blah blah blah blah blah blah blah blah blah blah blah blah blah blah 2015.


BRACKETED SPANS                                         *test-bracketed-spans*

_foo_ bar baz link <url>


PANVIMDOC-INCLUDE-COMMENT-CONTENT     *test-panvimdoc-include-comment-content*

Neovim is a great text editor.

Neovim supports |lua| plugins and is also:

- Multiplatform
- Open source


ALL CONTENT TYPES                                     *test-all-content-types*


ARE SUPPORTED ~

See neovim.org <https://neovim.org>.

==============================================================================
3. Links                                                          *test-links*

1. *caption*: image.png
2. *(**mapreduce?**)*:

Generated by panvimdoc <https://github.com/kdheepak/panvimdoc>

vim:tw=78:ts=8:noet:ft=help:norl:
""" == doc
end
