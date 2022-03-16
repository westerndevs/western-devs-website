---
title:  Unsupported Architecture for fsevents with Oryx
authorId: simon_timms
date: 2022-03-16
originalurl: https://blog.simontimms.com/2022/03/16/fsevents-optional-dependencies
mode: public
---



I updated the version of the lock file on a project the other day in the hopes it might restore a little bit more quickly. However for some steps in my build an older version of NPM was being used. This older version didn't have support for the new lock file version and while it is supposed to be compatible it seemed like optional dependencies like fsevents were causing a legit issue 

```
npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but package-lock.json was generated for lockfileVersion@2. I'll try to do my best with it!
npm ERR! code EBADPLATFORM
npm ERR! notsup Unsupported platform for fsevents@2.3.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
npm ERR! notsup Valid OS:    darwin
npm ERR! notsup Valid Arch:  any
npm ERR! notsup Actual OS:   linux
npm ERR! notsup Actual Arch: x64

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2022-03-09T13_58_42_006Z-debug.log
```

In theory these fsevent things should be warnings because they are optional dependencies. Updating the version of node used by Oryx, the build engine for Azure Static Web Apps, listens to the version of node defined in `package.config`. Adding this section to the `package.config` fixed everything

```
"engines": {
    "node": ">=16.0",
    "npm": ">=8.0"
  },
```