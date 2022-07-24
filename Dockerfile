FROM pandoc/core:2.17

RUN apk update && apk upgrade && apk add bash vim neovim

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh
COPY scripts/ /scripts/
COPY lib/Demojify.lua /usr/share/lua/common/Demojify.lua

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
