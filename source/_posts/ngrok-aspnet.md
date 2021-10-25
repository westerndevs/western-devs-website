---
title:  Using ngrok for ASP.NET
authorId: simon_timms
date: 2021-10-25
originalurl: https://blog.simontimms.com/2021/10/25/ngrok-aspnet
mode: public
---



If you try to just use ngrok like this 

```
ngrok http 1316
```

You're likely going to run into an issue when you browse to the website via the ngrok supplied URL that there are invalid host headers. This is because the local server is expecting headers for `localhost` and instead it is getting them for something like `https://3fe1-198-53-125-218.ngrok.io`. This can be solved by running with 

```
ngrok http 1316 -host-header="localhost:1316"
```