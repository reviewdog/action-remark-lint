#!/bin/bash
set -eu # Increase bash error strictness

if [[ -n "${GITHUB_WORKSPACE}" ]]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo "[action-remark-lint] Versions: $(remark --version), remark-lint: $(npm remark-lint --version)"

# Install plugins if package.json file is present
if [[ -f "package.json" ]]; then
  echo "[action-remark-lint] Installing npm dependencies..."
  npm install

  # Add default if `INPUT_REMARK_ARGS` is not set and no `remarkConfig` is found
  if ! grep -q '"remarkConfig"' package.json; then
    INPUT_REMARK_ARGS=${INPUT_REMARK_ARGS:=--use=remark-preset-lint-recommended}
  fi
fi

# Add default value if `INPUT_REMARK_ARGS` is not set and no `.remarkrc*` config file is found
if ! compgen -G .remarkrc* > /dev/null; then
  INPUT_REMARK_ARGS=${INPUT_REMARK_ARGS:=--use=remark-preset-lint-recommended}
fi

# NOTE: ${VAR,,} Is bash 4.0 syntax to make strings lowercase.
echo "[action-remark-lint] Checking markdown code with the remark-lint linter and reviewdog..."
remark . ${INPUT_REMARK_ARGS} 2>&1 |
  sed 's/\x1b\[[0-9;]*m//g' | # Removes ansi codes see https://github.com/reviewdog/errorformat/issues/51
  reviewdog -f=remark-lint \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    -tee \
    ${INPUT_REVIEWDOG_FLAGS}
