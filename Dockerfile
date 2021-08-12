FROM alpine:latest
LABEL maintainer="Dheepak Krishnamurthy me@kdheepak.com"

ENV PANDOC_VERSION=2.14.1

RUN apk --no-cache --update add make tree findutils vim neovim
RUN wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz \
    && tar -xvf pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz \
    && mv pandoc-${PANDOC_VERSION}/bin/pandoc /usr/local/bin \
    && rm -rf pandoc-${PANDOC_VERSION}*

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
