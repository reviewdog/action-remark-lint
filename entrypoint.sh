#!/bin/sh
set -e # Exit immediately if a command exits with a non-zero status

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ "${INPUT_REPORTER}" = 'github-pr-review' ]; then
  # erroformat: https://git.io/JeGMU
  echo "ERROR: github-pr-review unsupported (for now)"
  exit 1
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  remark --frail --quiet --use=remark-preset-lint-recommended . 2>&1 |
    reviewdog -f=remark-lint -name="remark-lint" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -tee
fi

remark --frail --quiet --use=remark-preset-lint-recommended . 2>&1 |
  sed 's/\x1b\[[0-9;]*m//g' | # Removes ansi codes see https://github.com/reviewdog/errorformat/issues/51
  reviewdog -f=remark-lint -name="remark-lint" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -tee