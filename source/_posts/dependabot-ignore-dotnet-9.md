---
title:  Limit Dependabot to .NET 8
authorId: simon_timms
date: 2024-11-20
originalurl: https://blog.simontimms.com/2024/11/20/dependabot-ignore-dotnet-9
mode: public
---



Just last week .NET 9 was realeased to much fanfare. There are a ton of cool and exciting things in it but for my current project I want to stick to a long term support version of .NET which is .NET 8. We might update later but for now 8 is great. Unfortunately dependabot isn't able to read my mind so it was continually proposing updating to .NET 9 packages. 

Fixing this is easy enough. I needed to add a couple of lines to my dependabot file to limit the sorts of updates it did to just minor and patch updates. Notice the `update-types` section. 

```
updates:
  - package-ecosystem: "nuget"
    directory: "/."
    groups:
      all_packages:
        update-types:
          - "minor"
          - "patch"
        patterns:
          - "*"
    open-pull-requests-limit: 50
    schedule:
      interval: "weekly"
```

With this in place dependabot is only proposing minor and patch updates to my .NET packages. It does mean that if we see other major version updates to non-Microsoft packages we'll have to manually update them. 