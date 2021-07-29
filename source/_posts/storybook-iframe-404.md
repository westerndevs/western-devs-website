---
title:  Storybook IFrame 404
authorId: simon_timms
date: 2021-07-29
originalurl: https://blog.simontimms.com/2021/07/29/storybook-iframe-404
mode: public
---



If you're running into a 404 on the IFrame on storybook the mostly likely cause is that your directory path to where storybook is contains some encoded characters. In this case we had a project called `Agent%20Portal` on disk. Renaming it to just `AgentPortal` fixed up storybook right away. 