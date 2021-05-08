---
title:  Download a file in powershell
authorId: simon_timms
date: 2021-05-08
originalUrl: https://blog.simontimms.com/2021/05/08/download-file.md
mode: public
---



Here is a quick way to download a file in powershell:

```
Invoke-WebRequest -Uri <source> -OutFile <destination>
```