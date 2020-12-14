# Reviewdog/action-remark-lint GitHub Action

[![Test](https://github.com/prologic/action-remark-lintworkflows/Test/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3ATest)
[![reviewdog](https://github.com/prologic/action-remark-lintworkflows/reviewdog/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3Areviewdog)
[![depup](https://github.com/prologic/action-remark-lintworkflows/depup/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3Adepup)
[![release](https://github.com/prologic/action-remark-lintworkflows/release/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-flake8?logo=github&sort=semver)](https://github.com/prologic/action-remark-lintreleases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)
[![Linux CI](https://github.com/prologic/action-remark-lintworkflows/Linux%20CI/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3A%22Linux+CI%22)
[![MacOS CI](https://github.com/prologic/action-remark-lintworkflows/MacOS%20CI/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3A%22MacOS+CI%22)
[![Windows CI](https://github.com/prologic/action-remark-lintworkflows/Windows%20CI/badge.svg)](https://github.com/prologic/action-remark-lintactions?query=workflow%3A%22Windows+CI%22)

This action runs [remark-lint](https://github.com/remarkjs/remark-lint) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Quickstart

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
        uses: prologic/action-remark-lint@v0.0.5
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-check # Change reporter. (Only `github-pr-check` is supported at the moment).
```

See the Inputs section below for details on the defaults and optional configuration settings.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### workdir

**Optional**. The directory to run remark-lint in. Default is `.`.

### `level`

**Optional**. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

**Optional**. Reporter of reviewdog command [github-pr-check,github-pr-review,github-check].
Default is github-pr-check. github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

**NB:** Only `github-pr-check` is supported currently.

#### `filter_mode`

**Optional**. Filtering mode for the reviewdog command [added, diff_context, file, nofilter]. Default = `"added"`.

#### `fail_on_error`

**Optional**. Exit code for reviewdog when errors are found [`true`, `false`]. Default = `false`.

#### `reviewdog_flags`

**Optional**. Additional reviewdog flags. Default = `""`.

#### `tool_name`

**Optional**. Tool name to use for reviewdog reporter. Default = `remark-lint`.

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)

You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: <https://help.github.com/en/articles/about-actions#versioning-your-action>

### Lint - reviewdog integration

This reviewdog action template itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

-   [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
-   [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
-   [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)

### Dependencies Update Automation

This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/reviewdog/action-template/pull/6)
