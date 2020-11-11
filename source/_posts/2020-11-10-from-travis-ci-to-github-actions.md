---
title: "From Travis CI to GitHub Actions (and GitHub Pages)"
date: "2020-11-10T18:36:00"
layout: post
authorId: david_wesst
originalurl: https://www.davidwesst.com/blog/from-travis-ci-to-github-actions
categories:
    - devops
tags:
    - github actions
    - github workflow
    - travis ci
    - continuous integration
    - continuous deployment
---

We recently migrated the continuous integration and deployment workflow for the Western Devs website from Travis CI to GitHub Actions. These are the steps I followed to get it done.

<!-- more -->

[1]: https://blog.travis-ci.com/2020-11-02-travis-ci-new-billing
[2]: https://docs.github.com/en/free-pro-team@latest/actions
[3]: https://westerndevs.com
[4]: https://github.com/westerndevs/western-devs-website/blob/master/.github/workflows/ci-cd.yml
[5]: https://www.davidwesst.com
[6]: https://hexo.io/
[7]: https://github.com/westerndevs/western-devs-website/blob/master/package.json
[8]: https://pages.github.com/
[9]: https://docs.github.com/en/free-pro-team@latest/actions/reference/context-and-expression-syntax-for-github-actions#about-contexts-and-expressions
[10]: https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets
[11]: https://github.com/marketplace?type=actions
[12]: https://api.slack.com/messaging/webhooks

Travis CI [announced a new pricing model][1] that _could_ have impact on open source projects that are using Travis for continuous integration and/or deployment. For static websites, like the [Western Devs website][3] or [personal website][5], this could result in getting some unforeseen costs. With that in mind, we decided to take the plunge an migrate away from Travis and over to [GitHub Actions][2] as they provide CI and CD workflows free for open source projects.

## TL;DR; -- Just show me the code
Fine. [Here is is][4]. It is open source after all.

But just to be clear, this isn't a tutorial on how to code this up, rather its a walkthrough on what it took to get our [Hexo][6] based static site from Travis to GitHub Actions.

## Start with Mapping Out Your Workflow
And I mean _workflow_ and not just the build. 

For the Western Devs, our workflow goes like this:

1. Commit a change to the code (i.e. a new blog post)
2. Build the website
3. If master branch build is successful, deploy the build to production
4. Notify the Western Devs of the build result in Slack

GitHub workflow provides everything we need to do this, and I'll walk you through the code, which you can see for yourself in [here in our GitHub repo][4].

### 1. Commit a change to the code (i.e. a new blog post)
This is our trigger to start the workflow. That is represented by the `on` section of the YAML. In our case, we want to trigger the workflow every time there is a pull request created for the master branch, a push to the master branch (i.e. a merge), or a push to any other feature (ft) or hotfix (hf) branches.

```yaml

name: CI/CD
on:
  push:
    branches:
      - master
      - ft/*
      - hf/*
  pull_request:
    branches: [ master ]

```

Now we have a workflow that will trigger when we want to. Next, we need to actually build the website.

### 2. Build the website
Our build is exceptionally simple-- just generate the site, and if the generation is successful, the build was successful. To do this, we create a `build` job that handles the work.

```yaml

jobs:
  build:
    name: Build and Deploy
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2 # checkout the source code
    - uses: actions/setup-node@v1 # setup the environment
      with:
        node-version: 12
    - run: npm install # setup dependencies
    - run: npm run build # run the build command

```

The first two steps are using GitHub Actions provided by GitHub themselves. This pulls our source code and the sets up the Node environment that we need to build the website. Once that is done, we  `run` steps to run shell commands to install our project specific dependendies and run the build script itself. 

The scripts have been defined in our [project `package.json` file][7] and are used by the developers to build the site locally as well.

### 3. If master branch build is successful, deploy the build to production
If we are talking about the master branch, we want to do a deployment if it is successful. For this step, we added a conditional expression using the `github` context that is provided to all actions. You can learn more about context and expressions for GitHub Actions in the [GitHub Docs here][9].

You might also see that were using an encrypted secret using the `secret.GITHUB_TOKEN` expression. All repositories have this feature in the settings section of the repo, and you can learn more about [creating encrypted secrets for a repository here][10] in the GitHub docs.

```yaml
    - name: Deploy to GitHub Pages
      if: github.ref == 'refs/heads/master'
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        cname: westerndevs.com
        commit_message: ${{ github.event.head_commit.message }}
```

#### BONUS: Free hosting with GitHub Pages
In our case, our deployment target is [GitHub Pages][8] which provides free hosting and SSL certificates for open source static sites sites like ours. 

We decided to take this opportunity to consilate everything under the GitHub umbrella because it saved us a couple of bucks, and now everything we need to manage the site is in one spot rather than spread across multiple cloud services.

### 4. Notify the Western Devs of the build result in Slack

Originally, we had forgotten this step and started to feel it right away. So an issue was created and I put a solution in place in about 15 minutes, thanks to someone else doing all the heavy lifting and publishing their work to the [GitHub Actions Marketplace][11].

Slack supports incoming webhooks, even for for free workspaces. I set that up by following the [Slack documentation][12], created another secret in our repository and voila, we were back in business wih the notifications.

```yaml
    - name: Notify Slack
      if: always()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        fields: repo,message,commit,author,action,eventName,ref,workflow,job,took # selectable (default: repo,message)
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }} # required
```

## Conclusion

The combination of GitHub Actions and GitHub Pages provides every developer with the opportunity to get a taste of DevOps while actually producing something they can show off to their peers and community. Travis CI is, and will continue to be, a great CI/CD solution for developers...but if you're looking for a one-stop-shop for source control, workflow, and hosting. You can't really go wrong with GitHub.
