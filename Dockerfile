FROM prologic/remark-lint:latest

ENV REVIEWDOG_VERSION=v0.12.0

RUN apk --no-cache add bash~=5.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN apk --no-cache -U add git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
