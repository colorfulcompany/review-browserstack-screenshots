# Review Browserstack Screenshots

## Usage

### Configuration
Configurations should be defined in `.screenshot/config.yaml` .
The following is a sample `.screenshot/config.yaml` .

```yaml
local: false # If true, take screenshots on http://localhost:8000.
table: false # The screenshot table in the comment.
browsers:
  - 
    os: OS X
    os_version: Big Sur
    browser: safari
    browser_version: 14.1
  -
    os: OS X
    os_version: Catalina
    browser: safari
    browser_version: 13.1
# ...
```

#### Available browsers

To know about all the available combinations, hit the Browser API. 

```bash
curl -u "<username>:<access_key>" https://api.browserstack.com/automate/browsers.json
```

### Workflow

#### Use external server

The following is a sample workflow.
```yaml
name: screenshot
on:
  pull_request:
    types:
      - opened
      - edited
      - synchronize
jobs:
  screenshot:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: colorfulcompany/review-browserstack-screenshots@main
        with:
          pr_number: ${{ github.event.pull_request.number }}
          commit_sha: ${{ github.event.pull_request.head.sha }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          browserstack_username: ${{ secrets.BROWSERSTACK_USERNAME }}
          browserstack_access_key: ${{ secrets.BROWSERSTACK_ACCESS_KEY }}
```

#### Use local server

The following is a sample workflow.
```yaml
name: screenshot
on:
  pull_request:
    types:
      - opened
      - edited
      - synchronize
jobs:
  screenshot:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7
          bundler-cache: true
      - uses: browserstack/github-actions/setup-env@master
        with:
          username:  ${{ secrets.BROWSERSTACK_USERNAME }}
          access-key: ${{ secrets.BROWSERSTACK_ACCESS_KEY }}
      - uses: browserstack/github-actions/setup-local@master
        with:
          local-testing: start
      - run: bundle exec jekyll serve --port 8000 & # entrypoint
      - uses: colorfulcompany/review-browserstack-screenshots@main
        with:
          pr_number: ${{ github.event.pull_request.number }}
          commit_sha: ${{ github.event.pull_request.head.sha }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          browserstack_username: ${{ secrets.BROWSERSTACK_USERNAME }}
          browserstack_access_key: ${{ secrets.BROWSERSTACK_ACCESS_KEY }}
      - uses: browserstack/github-actions/setup-local@master
        with:
          local-testing: stop
```

### Pull reqest keyword
Add a keyword like the following example to the PR description.

```markdown
screenshot https://example.com
```

If you want to take screenshots on local server, like this.

```markdown
screenshot /about
```

### Automatic Comment
![comment](https://github.com/cc-kawakami/review-browserstack-screenshots/blob/main/doc/comment.png)


## License
The scripts and documentation in this project are released under the MIT License
