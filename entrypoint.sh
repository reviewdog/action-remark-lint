#!/bin/bash
set -eu # Increase bash strictness
set -o pipefail

if [[ -n "${GITHUB_WORKSPACE}" ]]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# If no arguments are given use current working directory
remark_args=(".")
if [[ "$#" -eq 0 && "${INPUT_REMARK_FLAGS}" != "" ]]; then
  remark_args+=(${INPUT_REMARK_FLAGS})
elif [[ "$#" -ne 0 && "${INPUT_REMARK_FLAGS}" != "" ]]; then
  remark_args+=($* ${INPUT_REMARK_FLAGS})
elif [[ "$#" -ne 0 && "${INPUT_REMARK_FLAGS}" == "" ]]; then
  remark_args+=($*)
fi

# Run remark-lint with reviewdog
remark_exit_val="0"
reviewdog_exit_val="0"
if [[ "${INPUT_ANNOTATE,,}" = 'true' ]]; then
  echo "[action-remark-lint] Checking markdown code using the remark-lint linter and reviewdog..."
  remark_lint_output=$(remark --frail --quiet --use=remark-preset-lint-recommended ${remark_args[@]} 2>&1) ||
    remark_exit_val="$?"

  # Input remark formatter output to reviewdog
  echo "${remark_lint_output}" |
    sed 's/\x1b\[[0-9;]*m//g' | # Removes ansi codes see https://github.com/reviewdog/errorformat/issues/51
    reviewdog -f=remark-lint \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR,,}" \
      -level="${INPUT_LEVEL}" \
      -tee \
      ${INPUT_REVIEWDOG_FLAGS} || reviewdog_exit_val="$?"
else
  echo "[action-remark-lint] Checking markdown code using the remark-lint linter..."
  remark --frail --quiet --use=remark-preset-lint-recommended \
    ${remark_args[@]} 2>&1 || remark_exit_val="$?"
fi

# Check for remark/reviewdog errors
if [[ "${remark_exit_val}" -eq "0" && "${reviewdog_exit_val}" -eq "0" ]]; then
  remark_error="false"
  reviewdog_error="false"
elif [[ "${remark_exit_val}" -eq "1" && "${reviewdog_exit_val}" -eq "0" ]]; then
  remark_error="true"
  reviewdog_error="false"
elif [[ "${remark_exit_val}" -eq "1" && "${reviewdog_exit_val}" -eq "1" ]]; then
  remark_error="true"
  reviewdog_error="true"
elif [[ "${remark_exit_val}" -eq "0" && "${reviewdog_exit_val}" -eq "1" ]]; then
  remark_error="false"
  reviewdog_error="true"
else
  if [[ "${remark_exit_val}" -ne "0" && "${remark_exit_val}" -ne "1" && \
    "${reviewdog_exit_val}" -ne "0" && "${reviewdog_exit_val}" -ne "1" ]]; then
    # NOTE: Should not occur but just to be sure
    echo "[action-remark-lint] ERROR: Something went wrong while trying to run the remark" \
      "linter while annotating the changes using reviewdog (remark error code:" \
      "${remark_exit_val}, reviewdog error code: ${reviewdog_exit_val})."
    exit 1
  elif [[ "${remark_exit_val}" -ne "0" && "${remark_exit_val}" -ne "1" ]]; then
    # NOTE: Should not occur but just to be sure
    echo "[action-remark-lint] ERROR: Something went wrong while trying to run the remark" \
      "linter (error code: ${remark_exit_val})."
    exit 1
  else
    echo "[action-remark-lint] ERROR: Something went wrong while trying to run the" \
      "reviewdog error annotator (error code: ${reviewdog_exit_val})."
    exit 1
  fi
fi

# Also format code if this is requested
# NOTE: Useful for writing back changes or creating a pull request.
remark_format_exit_val="0"
if [[ "${INPUT_FORMAT,,}" = 'true' && "${remark_error}" = 'true' ]]; then
  echo "[action-remark-lint] Formatting python code using the remark linter..."
  remark --quiet --output --use=remark-preset-lint-recommended \
    ${remark_args[@]} 2>&1 || remark_format_exit_val="$?"

  # Check whether remark-lint formatting was succesfull
  if [[ "${remark_format_exit_val}" -eq "0" ]]; then
    remark_error="false"
    echo "::set-output name=is_formatted::true"
  elif [[ "${remark_format_exit_val}" -eq "1" ]]; then
    remark_error="true"
    echo "::set-output name=is_formatted::false"
  else
    # NOTE: Should not occur but just to be sure
    echo "[action-remark-lint] ERROR: Something went wrong while trying to format the" \
      "code using the remark linter (error code: ${remark_format_exit_val})."
    exit 1
  fi
elif [[ "${INPUT_FORMAT,,}" = 'true' && "${remark_error}" = 'false' ]]; then
  echo "[action-remark-lint] Formatting not needed."
  echo "::set-output name=is_formatted::false"
else
  echo "::set-output name=is_formatted::false"
fi

# Throw error if an error occurred and fail_on_error is true
if [[ "${INPUT_FAIL_ON_ERROR,,}" = 'true' && (\
  "${INPUT_ANNOTATE,,}" = 'false' && "${remark_error}" = 'true' || \
  "${INPUT_FORMAT,,}" = 'true' && "${remark_error}" = 'true' || \
  "${reviewdog_error}" = 'true') ]]; then
  exit 1
fi
