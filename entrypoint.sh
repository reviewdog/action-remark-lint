#!/bin/sh
set -e # Exit immediately if a command exits with a non-zero status

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

remark --frail --quiet --use=remark-preset-lint-recommended . ${INPUT_REMARK_FLAGS} 2>&1 |
  sed 's/\x1b\[[0-9;]*m//g' | # Removes ansi codes see https://github.com/reviewdog/errorformat/issues/51
  reviewdog -f=remark-lint \
  -name="${INPUT_TOOL_NAME}" \
  -reporter="${INPUT_REPORTER:-github-pr-check}"\
  -filter-mode="${INPUT_FILTER_MODE}" \
  -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
  -level="${INPUT_LEVEL}" \
  -tee \
  ${INPUT_REVIEWDOG_FLAGS}