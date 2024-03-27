FROM pandoc/core:3.1

RUN apk update && apk upgrade && apk add bash vim neovim

# Copies your code file  repository to the filesystem
COPY panvimdoc.sh /panvimdoc.sh
COPY panvimdoc.pre-commit.sh /panvimdoc.pre-commit.sh
COPY scripts/ /scripts/
COPY lib/Demojify.lua /usr/share/lua/common/lib/Demojify.lua

# change permission to execute the script and
RUN chmod +x /panvimdoc.sh
RUN chmod +x /panvimdoc.pre-commit.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/panvimdoc.sh"]
