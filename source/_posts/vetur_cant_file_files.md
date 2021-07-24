---
title:  Vetur Warnings in Azure Static Web App
authorId: simon_timms
date: 2021-07-24
originalurl: https://blog.simontimms.com/2021/07/24/vetur_cant_file_files
mode: public
---



I have a static web app that has directories for the front end written in Vue and the back end written in Azure functions. When I open it in VS Code I get warnings that Vetur can't find the `package.json` or `tsconfig.json`. This is because the Vue project isn't at the project root. This can be fixed by adding, at the root, a `vetur.config.js` containing a pointer to the web project. With my web project being in `web` (creative I know) the file looks like 


```javascript
// vetur.config.js
/** @type {import('vls').VeturConfig} */
module.exports = {
    // **optional** default: `{}`
    // override vscode settings
    // Notice: It only affects the settings used by Vetur.
    settings: {
      "vetur.useWorkspaceDependencies": true,
      "vetur.experimental.templateInterpolationService": true
    },
    // **optional** default: `[{ root: './' }]`
    // support monorepos
    projects: [
      './web'
    ]
  }
```