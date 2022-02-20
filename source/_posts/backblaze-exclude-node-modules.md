---
title:  Exclude node_modules from Backblaze Backups on Windows
authorId: simon_timms
date: 2022-02-20
originalurl: https://blog.simontimms.com/2022/02/20/backblaze-exclude-node-modules
mode: public
---



There are [some](https://chrisblackwell.me/ignore-node_modules-and-git-folders-in-backblaze/) [articles](https://gist.github.com/nickcernis/bb4bd43a44efd73b87d857e29b1d5b96) out there about how to exclude `node_modules` from Backblaze backups on OSX but I couldn't find anything about windows. 

What you want to do is open up `C:\ProgramData\Backblaze\bzdata\bzexcluderules_editable.xml` and add a new rule.

```xml
<excludefname_rule plat="win" osVers="*"  ruleIsOptional="t" skipFirstCharThenStartsWith="*" contains_1="node_modules" contains_2="*" doesNotContain="*" endsWith="*" hasFileExtension="*" />
```

If you want to exclude .git folders too (they can also contain a lot of small files that are slow to backup) also add 
```xml
<excludefname_rule plat="win" osVers="*"  ruleIsOptional="t" skipFirstCharThenStartsWith="*" contains_1=".git" contains_2="*" doesNotContain="*" endsWith="*" hasFileExtension="*" />
```