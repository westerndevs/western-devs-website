---
title:  Docker COPY not Finding Files 
authorId: simon_timms
date: 2023-11-23
originalurl: https://blog.simontimms.com/2023/11/23/cannot-copy
mode: public
---



My dad once told me that there are no such things a problems just solutions waiting to be applied. I don't know what book he'd just read or course he'd just been on to spout such nonsense but I've never forgotten it. 

Today my not problem was running a docker build wasn't copying the files I was expecting it to. In particular I had a `themes` directory which was not ending up in the image and in fact the build was failing with something like 

```
ERROR: failed to solve: failed to compute cache key: failed to calculate checksum of ref b1f3faa4-fdeb-41ed-b016-fac3862d370a::pjh3jwhj2huqmcgigjh9udlh2: "/themes": not found
```

I was really confused because `themes` absolutly did exist on disk. It was as if it wasn't being added to the build context. In fact it wasn't being added and, as it turns out, this was because my .dockerignore file contained 
```
**
```

Which ignores everything from the local directory. That seemed a bit extreme so I changed it to 
```
** 
!themes
```

With this in place the build worked as expected.