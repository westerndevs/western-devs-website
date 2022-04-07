---
title:  Azure Functions Provider Error
authorId: simon_timms
date: 2022-04-07
originalurl: https://blog.simontimms.com/2022/04/07/azure-functions-error
mode: public
---



I started up a previously working Azure functions project today that I hadn't touched in a week. It failed to start with an error like this

```
A host error has occurred during startup operation 'b59ba8b8-f264-4274-a9eb-e17ba0e02ed8'.
api: Could not load file or assembly 'Microsoft.Extensions.Options, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. The system cannot find the file specified.
Value cannot be null. (Parameter 'provider')
```

This is the sort of error that terrifies me. Something is wrong but who knows what. No changes in git and an infinity of generic errors on google for `Could not load file or assembly`. Eventually after some digging it seems like I might be suffering from some corrupted tooling (some hints about that here: https://github.com/Azure/azure-functions-core-tools/issues/2232). I was able to fix mine by downloading the latest version of the tooling from https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash