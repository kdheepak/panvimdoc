@testset "markdown" begin
  doc = test_pandoc(
    raw"""
## :sparkles: Features

## :zap: Requirements

## :package: Installation

### Telescope extension

### Lazy loading

## :rocket: Usage

## :wrench: Configuration

### Defaults

### Session options

### Session save location

### Git branching

### Autosaving

### Autoloading

### Following current working directory

### Allowed directories

### Ignored directories

### Events / Callbacks

### Telescope extension

## :page_with_curl: License

    """;
    toc = true,
    demojify = true,
    dedup_subheadings = true,
  )
  @test raw"""
*test.txt*                                                    Test Description

==============================================================================
Table of Contents                                     *test-table-of-contents*

  - Features                                                   |test-features|
  - Requirements                                           |test-requirements|
  - Installation                                           |test-installation|
  - Usage                                                         |test-usage|
  - Configuration                                         |test-configuration|
  - License                                                     |test-license|

FEATURES                                                       *test-features*


REQUIREMENTS                                               *test-requirements*


INSTALLATION                                               *test-installation*


TELESCOPE EXTENSION ~


LAZY LOADING ~


USAGE                                                             *test-usage*


CONFIGURATION                                             *test-configuration*


DEFAULTS ~


SESSION OPTIONS ~


SESSION SAVE LOCATION ~


GIT BRANCHING ~


AUTOSAVING ~


AUTOLOADING ~


FOLLOWING CURRENT WORKING DIRECTORY ~


ALLOWED DIRECTORIES ~


IGNORED DIRECTORIES ~


EVENTS / CALLBACKS ~


TELESCOPE EXTENSION ~


LICENSE                                                         *test-license*

Generated by panvimdoc <https://github.com/kdheepak/panvimdoc>

vim:tw=78:ts=8:noet:ft=help:norl:
""" == doc
end