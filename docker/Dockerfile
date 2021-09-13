FROM node:current-alpine

WORKDIR /usr/app

RUN apk --no-cache add git~=2.30 bash~=5.1

ENV REVIEWDOG_VERSION=v0.13.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY entrypoint.sh package.json package-lock.json ./
RUN chmod +x entrypoint.sh && \
    npm install && \
    rm package*.json && \
    npx remark-cli --version > /usr/app/remark_version

ENTRYPOINT ["/usr/app/entrypoint.sh"]
