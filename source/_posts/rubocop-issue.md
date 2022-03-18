---
title:  Fixing VS Code Rubocop Issues 
authorId: simon_timms
date: 2022-03-18
originalurl: https://blog.simontimms.com/2022/03/18/rubocop-issue
mode: public
---



I run this rubocop extension in my VS Code

![rubocop extension](/images/2022-03-18-rubocop-issue.md/2022-03-18-10-15-48.png))

Recently the project I was on did a Ruby update and my rubocop stopped working with an error like this

![Rubocop error](/images/2022-03-18-rubocop-issue.md/2022-03-18-10-16-43.png))

The issue here was that the rubocop in the project was newer than the globally installed rubocop so it was returning empty output. This extension doesn't look like it uses `rbenv` properly so I needed to globally update rubocop which I did with 

```bash
/usr/local/bin/rubocop -v  -> 1.22.3
sudo gem install rubocop
/usr/local/bin/rubocop -v  -> 1.26
```

I still had some errors about missing rules and needed to also do 

```bash
sudo gem install rubocop-rake
sudo gem install rubocop-rails
sudo gem install rubocop-performance
```

Ideally I'd like this extension to use the rbenv version of ruby but this gets me sorted for now. 