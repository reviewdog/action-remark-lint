# Reviewdog/action-remark-lint GitHub Action

[![Test](https://github.com/reviewdog/action-remark-lint/workflows/Test/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/reviewdog/action-remark-lint/workflows/reviewdog/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/reviewdog/action-remark-lint/workflows/depup/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-remark-lint/workflows/release/badge.svg)](https://github.com/reviewdog/action-remark-lint/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-remark-lint?logo=github\&sort=semver)](https://github.com/reviewdog/action-remark-lint/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github\&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![action screenshot](https://user-images.githubusercontent.com/17570430/102060312-4ee5e000-3df2-11eb-8c82-767afeccd8db.png)
![action screenshot](https://user-images.githubusercontent.com/17570430/102059912-d3842e80-3df1-11eb-9b0a-2e04eab5e294.png)

This action runs [remark-lint](https://github.com/remarkjs/remark-lint) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience. It can be used to format your code and/or annotate possible changes that would be made during this formatting.

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
        uses: reviewdog/action-remark-lint@v1
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

**Optional**. Report level for reviewdog \[info, warning, error].
It's same as `-level` flag of reviewdog.

### `reporter`

**Optional**. Reporter of reviewdog command \[github-pr-check, github-pr-review, github-check].
Default is github-pr-check. github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

**NB:** Only `github-pr-check` is supported currently.

#### `filter_mode`

**Optional**. Filtering mode for the reviewdog command \[added, diff_context, file, nofilter]. Default = `"added"`.

#### `fail_on_error`

**Optional**. Exit code for reviewdog when errors are found \[`true`, `false`]. Default = `false`.

#### `reviewdog_flags`

**Optional**. Additional reviewdog flags. Default = `""`.

#### `tool_name`

**Optional**. Tool name to use for reviewdog reporter. Default = `remark-lint`.

## Docker input args

Besides the aforementioned input arguments you can also supply additional input arguments for the remark-lint linter using the args keyword [run.args](https://docs.github.com/en/free-pro-team@latest/actions/creating-actions/metadata-syntax-for-github-actions#runsargs).

```yaml
runs:
  using: 'docker'
  image: 'Dockerfile'
  args: ". --verbose"
```

## Advance use cases

This action can be combined with [peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request) or [stefanzweifel/git-auto-commit-action](https://github.com/stefanzweifel/git-auto-commit-action) to also apply the annotated changes to the repository.

### Commit changes

```yaml
name: reviewdog
on: [pull_request]
jobs:
  name: runner / remark-lint
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v2
      with:
        ref: ${{ github.head_ref }}
    - name: Check files using remark-lint linter
      uses: reviewdog/action-remark-lint@v1
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        reporter: github-check
        level: error
        fail_on_error: true
        format: true
    - name: Commit remark-lint formatting results
      if: failure()
      uses: stefanzweifel/git-auto-commit-action@v4
      with:
        commit_message: ":art: Format markdown code with remark-lint push"
```

### Create pull request

```yaml
name: reviewdog
on: [pull_request]
jobs:
  name: runner / remark-lint
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v2
    - name: Check files using remark-lint linter
      uses: reviewdog/action-remark-lint@v1
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        reporter: github-check
        level: error
        fail_on_error: true
        format: true
    - name: Create Pull Request
      if: failure()
      uses: peter-evans/create-pull-request@v3
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        title: "Format markdown code with remark-lint linter"
        commit-message: ":art: Format markdown code with remark-lint linter"
        body: |
          There appear to be some python formatting errors in ${{ github.sha }}. This pull request
          uses the [remark-lint](https://github.com/remarkjs/remark-lint) linter to fix these issues.
        branch: actions/remark-lint
```
