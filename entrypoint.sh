#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

if [[ -n "${GITHUB_WORKSPACE}" ]]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# If no arguments are given use current working directory
if [[ "$#" -eq 0 ]]; then
  remark_args="."
else
  remark_args="$*"
fi

# Check if formatting is requested
if [[ "${INPUT_FORMAT}" = 'true' ]]; then
  format_str="Format"
  format_arg="-o"
else
  format_str="Check"
  format_arg=""
fi

# Run black with reviewdog
remark_lint_error="false"
reviewdog_error="false"
if [[ "${INPUT_ANNOTATE}" = 'true' ]]; then
  echo "[action-remark-lint] ${format_str} markdown code using the remark-lint linter..."
  remark --frail --quiet --use=remark-preset-lint-recommended "${format_arg}" "${INPUT_WORKDIR}/${remark_args}" 2>&1 |
    sed 's/\x1b\[[0-9;]*m//g' | # Removes ansi codes see https://github.com/reviewdog/errorformat/issues/51
    reviewdog -f=remark-lint                  \
      -name="${INPUT_TOOL_NAME}"              \
      -reporter="${INPUT_REPORTER}"           \
      -filter-mode="${INPUT_FILTER_MODE}"     \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}"                 \
      -tee                                    \
      ${INPUT_REVIEWDOG_FLAGS} || reviewdog_error="true"
  remark_exit_val="${PIPESTATUS[0]}"
  if [[ "${remark_exit_val}" -ne "0" ]]; then
    remark_lint_error="true"
  elif [[ "${remark_exit_val}" -eq "0" && "${INPUT_FORMAT}" = 'true' ]]; then
    echo "[action-remark-lint] Formatting not needed."
  fi
else
  echo "[action-remark-lint] ${format_str} markdown code using the remark-lint linter..."
  remark --frail --quiet \
  --use=remark-preset-lint-recommended "${format_arg}" "${INPUT_WORKDIR}/${remark_args}" 2>&1 || reviewdog_error="true"
  remark_exit_val="${PIPESTATUS[0]}"
  if [[ "${remark_exit_val}" -ne "0" ]]; then
    remark_lint_error="true"
  elif [[ "${remark_exit_val}" -eq "0" && "${INPUT_FORMAT}" = 'true' ]]; then
    echo "[action-remark-lint] Formatting not needed."
  fi
fi

# Throw error if an error occurred and fail_on_error is true
if [[ ("${reviewdog_error}" = 'true' || "${remark_lint_error}") && "${INPUT_FAIL_ON_ERROR}" = 'true' ]]; then
  exit 1
fi
