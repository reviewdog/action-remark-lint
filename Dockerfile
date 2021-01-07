FROM prologic/remark-lint:latest

ENV REVIEWDOG_VERSION=v0.11.0-nightly20201213+85edbc6

RUN apk add --no-cache bash git

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/nightly/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN apk --no-cache -U add git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
