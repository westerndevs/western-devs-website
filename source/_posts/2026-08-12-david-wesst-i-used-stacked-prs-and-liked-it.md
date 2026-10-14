---
layout: post
title: I Used Stacked PRs and Liked It
date: '2026-08-12T12:00:00'
updated: '2026-08-12T12:00:00'
authorId: david_wesst
tags:
  - devops
  - github
  - pull-requests
categories:
  - devops
excerpt: >-
  Stacked pull requests helped me organize and merge a set of dependent changes
  to this website—and gave me a little faith in GitHub as a platform again.
description: >-
  Stacked pull requests helped me organize and merge a set of dependent changes
  to this website—and gave me a little faith in GitHub as a platform again.
originalurl: 'https://david.wes.st/blog/i-used-stacked-prs-and-liked-it/'
crosspostId: 9f4f72c30178f0f90e22b93b92c171fef008028a3973d84334d9bcf99fe691a2
sourceCommit: 8e00fa8f6fbc7fac31e4d7fcb9037c90d7f19f37
sourceBuildId: local-80b25e6b-065c-4761-80c3-5a5d5b6e3448
---

{% raw %}
<img src="/images/david-wesst/2026-08-12-david-wesst-i-used-stacked-prs-and-liked-it/4365f2207e3a1acb-i-used-stacked-prs-and-liked-it_banner.png" alt="GitHub's Octocat logo beside terminal output listing five branches in a stacked pull request">
<p>Stacked pull requests helped me organize and merge a set of dependent changes to this website—and gave me a little faith in GitHub as a platform again.</p>
<p>GitHub introduced a non-AI-focused feature called <a href="https://docs.github.com/en/pull-requests/how-tos/stacked-pull-requests">Stacked Pull Requests</a> that helps you merge multiple PRs at once. This is the first feature since the introduction of <a href="https://docs.github.com/en/issues/planning-and-tracking-with-projects">Projects</a> that has interested me in years, and it has given me a bit of faith in GitHub as a platform again.</p>
<h2>Why Did I Use Stacked PRs?</h2>
<p>I heard about Stacked PRs through the <a href="https://www.westerndevs.com/">Western Devs</a> (yes, we still talk, we just don't blog as much) and thought I would use them to "stack" a bunch of changes I wanted to apply to my website. My website has been something of a forever hobby project that I use to experiment with various technologies and keep my hands a little dirty when it comes to web tooling.</p>
<p>In any case, there were a number of features I wanted to apply to relaunch the site, but I knew it would be a massive change to the project. Between data migrations, new styling, and a new site structure, the change logs were going to be massive.</p>
<p>So, instead of one gigantic PR or having a bunch of PRs that I have to keep track of myself, I decided to try stacked PRs to keep track of the merge order for me.</p>
<p>Here are a couple of images of the CLI and Web UIs for stacked PRs from GitHub that I used:</p>
<p><img src="/images/david-wesst/2026-08-12-david-wesst-i-used-stacked-prs-and-liked-it/22173f6080b92dc6-gh-stack_terminal.png" alt="A black terminal window showing the CLI output for the gh stack view command, with five PRs ready to be merged">
<img src="/images/david-wesst/2026-08-12-david-wesst-i-used-stacked-prs-and-liked-it/ebfedab31d401783-gh-stack_web.png" alt="The GitHub web interface for a PR showing the stacked PR section, with five green checkboxes lined up for five separate branches. A green &quot;Merge stack&quot; button is at the bottom of the widget, with a green &quot;Preview&quot; tag in the bottom-right corner."></p>
<h2>Were Stacked PRs Useful?</h2>
<p>Put simply: yes.</p>
<p>It sounds like a simple task, but even keeping my side project branches organized is difficult for me. I have tried keeping notes in the PRs themselves and organizing myself around milestones, but nothing really worked because it didn't tie everything together on the workflow side of things.</p>
<p>With my CI/CD pipelines in place, stacked PRs made it easy for me to order the branches properly, add new ones when necessary, and highlight where things would fail early when merging them altogether.</p>
<p><img src="/images/david-wesst/2026-08-12-david-wesst-i-used-stacked-prs-and-liked-it/7bb1014bcc3b38e2-gh-stack_cli_merging.png" alt="Terminal output with a black background and a text-based UI showing &quot;Select PRs&quot; highlighted, with green checked boxes for five branches being merged. The message &quot;Will merge 5 PRs into main&quot; appears in grey, with navigation commands at the bottom."></p>
<h2>This Isn't Groundbreaking Though-- Is It?</h2>
<p>No, of course not.</p>
<p>Honestly, I had been considering moving away from GitHub since they only seem to talk about generative AI coding. I'm not against AI coding, but that isn't the ONLY reason I use GitHub. In fact, I don't use GitHub Copilot; I use Codex for AI code assistance.</p>
<p>My point is that GitHub is a social coding platform with DevOps tooling, and if they aren't in that business anymore, then I should take the time to learn a toolset that does care about DevOps tooling.</p>
<p>I will save that for another post.</p>

{% endraw %}
