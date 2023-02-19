@testset "toc" begin
  doc = test_pandoc(
    raw"""
  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax.

-------     ------ ----------   -------
     12     12        12             12
    123     123       123           123
      1     1          1              1
-------     ------ ----------   -------

-------------------------------------------------------------
 Centered   Default           Right Left
  Header    Aligned         Aligned Aligned
----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here's another one. Note
                                    the blank line between
                                    rows.
-------------------------------------------------------------

Table: Here's the caption. It, too, may span
multiple lines.

----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here's another one. Note
                                    the blank line between
                                    rows.
----------- ------- --------------- -------------------------

: Here's a multiline table without a header.


: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+

Cells can span multiple columns or rows:

+---------------------+----------+
| Property            | Earth    |
+=============+=======+==========+
|             | min   | -89.2 °C |
| Temperature +-------+----------+
| 1961-1990   | mean  | 14 °C    |
|             +-------+----------+
|             | min   | 56.7 °C  |
+-------------+-------+----------+

A table header may contain more than one row:

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

+---------------+---------------+--------------------+
| Right         | Left          | Centered           |
+==============:+:==============+:==================:+
| Bananas       | $1.34         | built-in wrapper   |
+---------------+---------------+--------------------+

| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

fruit| price
-----|-----:
apple|2.05
pear|1.37
orange|3.09

| One | Two   |
|-----+-------|
| my  | table |
| is  | nice  |
    """;
    toc = false,
  )
  @test doc == raw"""
*test.txt*                                                    Test Description

    Right Left    Center  Default
  ------- ------ -------- ---------
       12 12        12    12
      123 123      123    123
        1 1         1     1

  : Demonstration of simple table syntax.
  ----- ----- ----- -----
     12 12     12      12
    123 123    123    123
      1 1       1       1
  ----- ----- ----- -----
  ---------------------------------------------------------------
   Centered   Default     Right Aligned Left Aligned
    Header    Aligned                   
  ----------- --------- --------------- -------------------------
     First    row                  12.0 Example of a row that
                                        spans multiple lines.

    Second    row                   5.0 Here’s another one. Note
                                        the blank line between
                                        rows.
  ---------------------------------------------------------------

  : Here’s the caption. It, too, may span multiple lines.
  ----------- ------- --------------- -------------------------
     First    row                12.0 Example of a row that
                                      spans multiple lines.

    Second    row                 5.0 Here’s another one. Note
                                      the blank line between
                                      rows.
  ----------- ------- --------------- -------------------------

  : Here’s a multiline table without a header.
+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | -   built-in       |
|               |               |     wrapper        |
|               |               | -   bright color   |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | -   cures scurvy   |
|               |               | -   tasty          |
+---------------+---------------+--------------------+

: Sample grid table.
Cells can span multiple columns or rows:

  --------------------------------
  Property              Earth
  ------------- ------- ----------
  Temperature   min     -89.2 °C
  1961-1990             

                mean    14 °C

                min     56.7 °C
  --------------------------------
A table header may contain more than one row:

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
  ----------------------------------------------------
            Right Left                  Centered
  --------------- --------------- --------------------
          Bananas $1.34             built-in wrapper

  ----------------------------------------------------
    Right Left   Default    Center
  ------- ------ --------- --------
       12 12     12           12
      123 123    123         123
        1 1      1            1
  fruit      price
  -------- -------
  apple       2.05
  pear        1.37
  orange      3.09
  One   Two
  ----- -------
  my    table
  is    nice

Generated by panvimdoc <https://github.com/kdheepak/panvimdoc>

vim:tw=78:ts=8:noet:ft=help:norl:
"""
end
