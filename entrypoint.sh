#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ "${INPUT_REPORTER}" = 'github-pr-review' ]; then
  # erroformat: https://git.io/JeGMU
  echo "ERROR: github-pr-review unsupported (for now)"
  exit 1
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  remark . -use preset-lint-markdown-style-guide |
    reviewdog -f="checkstyle" -name="remark-lint" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}"
fi
