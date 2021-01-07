#!/bin/bash
set -eu # Increase bash strictness
set -o pipefail

# If no arguments are given use current working directory
remark_args=(".")
if [[ "$#" -eq 0 && "${INPUT_REMARK_FLAGS}" != "" ]]; then
  remark_args+=(${INPUT_REMARK_FLAGS})
elif [[ "$#" -ne 0 && "${INPUT_REMARK_FLAGS}" != "" ]]; then
  remark_args+=($* ${INPUT_REMARK_FLAGS})
elif [[ "$#" -ne 0 && "${INPUT_REMARK_FLAGS}" == "" ]]; then
  remark_args+=($*)
else
  # Default (if no args provided).
  remark_args+=("--frail" "--quiet")
fi

# Check if formatting was requested
regex='(\s+-[a-zA-Z]*o[a-zA-Z]*\s?|--output)'
if [[ "${remark_args[*]}" =~ $regex ]]; then
  formatting="true"
  remark_print_str="Formatting"
else
  formatting="false"
  remark_print_str="Checking"
fi

remark_exit_val="0"
echo "[action-remark-lint] Checking ${remark_print_str} code using the remark-lint linter and reviewdog..."
remark_lint_output="$(remark --use=remark-preset-lint-recommended ${remark_args[*]} 2>&1)" ||
  remark_exit_val="$?"
echo "${remark_lint_output}"

# Check for remark-lint errors
if [[ "${formatting}" != "true" ]]; then
  echo "::set-output name=is_formatted::false"
  if [[ "${remark_exit_val}" -eq "0" ]]; then
    remark_error="false"
  elif [[ "${remark_exit_val}" -eq "1" ]]; then
    remark_error="true"
  else
    echo "[action-remark-lint] ERROR: Something went wrong while trying to run the" \
      "remark-lint linter (error code: ${remark_exit_val})."
    exit 1
  fi
else

  # Check if remark-lint linter formatted files
  # Note: We use git since parsing wont help if the user supplied the '-s' or '-q' flags
  changed_files=$(git status --porcelain | grep .md | wc -l)
  if [[ ${changed_files} -eq 0 ]]; then
    echo "::set-output name=is_formatted::false"
  else
    echo "::set-output name=is_formatted::true"
  fi

  # Check remark-lint error
  if [[ "${remark_exit_val}" -eq "0" ]]; then
    remark_error="false"
  elif [[ "${remark_exit_val}" -eq "1" ]]; then
    remark_error="true"
  else
    echo "::set-output name=is_formatted::false"
    echo "[action-remark-lint] ERROR: Something went wrong while trying to run the" \
      "remark-lint linter (error code: ${remark_exit_val})."
    exit 1
  fi
fi

# Throw error if an error occurred and fail_on_error is true
if [[ "${INPUT_FAIL_ON_ERROR,,}" = 'true' && "${remark_error}" = 'true' ]]; then
  exit 1
fi
