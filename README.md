# Reviewdog/action-remark-lint GitHub Action

[![Test](https://github.com/reviewdog/action-remark-lint/workflows/Test/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-remark-lint/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-remark-lint/workflows/depup/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-remark-lint/workflows/release/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-remark-lint?logo=github\&sort=semver)](https://github.com/reviewdog/action-remark-lint/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github\&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![action screenshot](https://user-images.githubusercontent.com/17570430/102060312-4ee5e000-3df2-11eb-8c82-767afeccd8db.png)
![action screenshot](https://user-images.githubusercontent.com/17570430/102059912-d3842e80-3df1-11eb-9b0a-2e04eab5e294.png)

This action runs [remark-lint](https://github.com/remarkjs/remark-lint) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Quick start

In it's simplest form this action can be used to annotate the changes that are suggested by the [remark-lint](https://github.com/remarkjs/remark-lint) linter.

```yml
name: reviewdog
on: [pull_request]
jobs:
  remark-lint:
    name: runner / remark-lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: remark-lint
        uses: reviewdog/action-remark-lint@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-check # Change reporter. (Only `github-pr-check` is supported at the moment).
```

## Inputs

### `github_token`

**Required**. The [GITHUB_TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow). Must be in form of `github_token: ${{ secrets.github_token }}`. Defaults to `${{ github.token }}`.

### `workdir`

**Optional**. The directory to run remark-lint in. Defaults to `.`.

### `format`

**Optional**. If true, remark-lint format files and commit are creatable (use other Action). Defaults to `false`.

#### `remark_flags`

**Optional**. Additional remark-lint flags. Defaults to `""`.

### `annotate`

**Optional**. Annotate remark-lint changes using reviewdog. Defaults to `true`.

#### `tool_name`

**Optional**. Tool name to use for reviewdog reporter. Defaults to `remark-lint`.

### `level`

**Optional**. Report level for reviewdog `[info, warning, error]`. It's same as `-level` flag of reviewdog. Defaults to `error`.

### `reporter`

**Optional**. Reporter of reviewdog command `[github-pr-check, github-pr-review, github-check]`.
Default is `github-pr-check`. `github-pr-review` can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

**Optional**. Filtering mode for the reviewdog command `[added, diff_context, file, nofilter]`. Defaults to `added`.

#### `fail_on_error`

**Optional**. Exit code for when reviewdog when errors are found `[true, false]`. Defaults to `false`.

### `reviewdog_flags`

**Optional**. Additional reviewdog flags. Defaults to `""`.

## Format your code

This action is meant to annotate any possible changes that would need to be made to make your code adhere to the [remark-lint linting guidelines](https://github.com/remarkjs/remark-lint). It does not apply these changes to your codebase. If you also want to apply the changes to your repository, you can use the [reviewdog/action-suggester](https://github.com/reviewdog/action-suggester). You can find examples of how this is done can be found in [rickstaa/action-remark-lint](https://github.com/rickstaa/action-remark-lint/)
