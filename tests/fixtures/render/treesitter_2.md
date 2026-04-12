Here's a YAML codeblock:

```yaml
name: panvimdoc
on: [push]
jobs:
  docs:
    runs-on: ubuntu-latest
    name: pandoc to vimdoc
    steps:
      - uses: actions/checkout@v2
```
