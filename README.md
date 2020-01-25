# GitHub Action: Run remark-lint with reviewdog

Based on [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)

[![Docker Image CI](https://github.com/prologic/action-remark-lint/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/prologic/action-remark-lint/actions)
[![Release](https://img.shields.io/github/release/prologic/action-remark-lint.svg?maxAge=43200)](https://github.com/prologic/action-remark-lint/releases)

This action runs [remark-lint](https://github.com/remarkjs/remark-lint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

[![github-pr-check sample](https://user-images.githubusercontent.com/3797062/65701219-e828b980-e0bb-11e9-9051-2a1f400fe5e5.png)](https://github.com/prologic/action-remark-lint/pull/1)
[![github-pr-review sample](https://user-images.githubusercontent.com/3797062/65700741-1c4faa80-e0bb-11e9-8cbd-9a99aeb38594.png)](https://github.com/prologic/action-remark-lint/pull/1)

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-pr-review,github-check].
Default is github-pr-check.
github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `path`

Optional. Base directory to run remark-lint. Same as `[path]` of `find` command. Default: `.`

### `pattern`

Optional. File patterns of target files. Same as `-name [pattern]` of `find` command. Default: `*.sh`

### `exclude`

Optional. Exclude patterns of target files. Same as `-not -path [exclude]` of `find` command.
e.g. `./git/*`

### `remark-lint_flags`

Optional. Flags of remark-lint command. Default: ``

## Example usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

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
        uses: prologic/action-remark-lint@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review # Change reporter.
          path: "." # Optional.
          pattern: "*.sh" # Optional.
          exclude: "./.git/*" # Optional.
```
