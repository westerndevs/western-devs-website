---
title:  Consuming Github Packages in Yarn
authorId: simon_timms
date: 2024-11-05
originalurl: https://blog.simontimms.com/2024/11/05/consuming-github-packges-in-yarn
mode: public
---



My life is never without adventure but unfortunately it isn't the living on a beach sort of adventure. No it's the installing yarn packages. I wanted to have a package installed in my project which was one I'd published from another repository. In this case the package was called `@stimms/uicomponents`. There were a few tricks to getting Github actions to be able to pull the package: first I needed to create a .yarnrc.yml file. This gives yarn instructions about where it should look for packages. 

```yml
nodeLinker: node-modules

npmScopes:
  stimms:
    npmRegistryServer: "https://npm.pkg.github.com"
    
npmRegistries:
  "https://npm.pkg.github.com":
    npmAlwaysAuth: true
```

Now in the build I needed to add a step in to populate the GITHUB_TOKEN which can be used for authentication. I found quite a bit of documentation which suggested that the .yarnrc.yml file would be able to read the environment variable but I had no luck with that approach. Instead I added a step to the build to populate the GITHUB_TOKEN in the .npmrc file. 

```yml
- name: Configure GitHub Packages Auth
    run: echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" > ~/.npmrc
    env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
- name: Build
    run: |
    yarn install
    yarn lint
    yarn build
```

The final thing to remember is that by default the GITHUB_TOKEN here doesn't have read permission over your packages. You'll need to go into the package settings and add the repository to the list of repositories which can use the package. You just need read access.  If you don't do this step you're going to see an error like `error Error: https://npm.pkg.github.com/@stimms%2fuicomponents: authentication token not provided`

