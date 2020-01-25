# GitHub Action: Run remark-lint with reviewdog

Based on [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)

[![Docker Image CI](https://github.com/prologic/action-remark-lint/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/prologic/action-remark-lint/actions)
[![Release](https://img.shields.io/github/release/prologic/action-remark-lint.svg?maxAge=43200)](https://github.com/prologic/action-remark-lint/releases)

This action runs [remark-lint](https://github.com/remarkjs/remark-lint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

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

**NB:** Only `github-pr-check` is supported currently.

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
          reporter: github-pr-review # Change reporter. (Only `github-pr-check` is supported at the moment).
```
