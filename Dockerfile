FROM pandoc/core:2.17

RUN apk update && apk upgrade && apk add bash vim neovim

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh
COPY scripts/skip-blocks.lua /scripts/skip-blocks.lua
COPY scripts/include-files.lua /scripts/include-files.lua
COPY scripts/panvimdoc.lua /scripts/panvimdoc.lua

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
