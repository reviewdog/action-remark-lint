FROM node:current-alpine

RUN apk --no-cache add git~=2.30 bash~=5.1

ENV REVIEWDOG_VERSION=v0.13.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN npm install -g remark-cli@latest remark-preset-lint-recommended@latest remark-lint@latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]