#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ "${INPUT_REPORTER}" = 'github-pr-review' ]; then
  # erroformat: https://git.io/JeGMU
  echo "ERROR: github-pr-review unsupported (for now)"
  exit 1
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  remark --quiet --use=remark-preset-lint-recommended . 2>&1 |
    reviewdog -efm="%f\n%l:%c: %m" -name="remark-lint" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -tee
fi
