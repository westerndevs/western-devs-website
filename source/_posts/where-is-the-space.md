---
title:  Where is the disk space?
authorId: simon_timms
date: 2024-11-10
originalurl: https://blog.simontimms.com/2024/11/10/where-is-the-space
mode: public
---



I had a report today from somebody unable to log into our Grafana instance. Super weird because this this has been running fine for months and we haven't touched it. So I jumped onto the machine to see what was up. First up was just looking at the logs from Grafana. 

```
docker logs -f --tail 10 5efd3ee0074a
```

There in the logs was the culprit `No space left on device`. Uh oh, what's going on here? Sure enough the disk was full. 

```
df -h
```

```
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              1.6G  1.9M  1.6G   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   96G   93G     0 100% /
tmpfs                              7.8G     0  7.8G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  182M  1.7G  10% /boot
tmpfs                              1.6G   12K  1.6G   1% /run/user/1001
```

This stuff is always annoying because you get to a point where you can't run any commands because there is no space left. I started with cleaning up some small parts of docker 

`docker system prune -a`

Then cleaned up docker logs 

`sudo truncate -s 0 /var/lib/docker/containers/**/*-json.log`

This then gave me enough space to run `docker system df` and see where the space was being used. Containers were the culprit. So next was to run 

`docker ps --size`

Which showed me the web scraper container had gone off the rails and was using over a 100GiB of space. 

```
7cf14084c56a   webscraper:latest       "wsce start -v -y"       7 weeks ago   Up 20 minutes               0.0.0.0:7002->9924/tcp, [::]:7002->9924/tcp                                webscraper       123GB (virtual 125GB)
```

This thing is supposed to be stateless so I just killed an removed it. 

```
docker kill 7cf14084c56a
docker rm 7cf14084c56a
docker compose up -d webscraper
```

After a few minutes these completed and all was good again. So we'll keep an eye on that service and perhaps reboot it every few months to keep it in check.