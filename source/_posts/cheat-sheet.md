---
title:  Redis Cheat Sheet
# Running in Docker 
# Connection
# Querying 
authorId: simon_timms
date: 2022-04-04
originalurl: https://blog.simontimms.com/2022/04/04/cheat-sheet
mode: public 
---



## Running in Docker 

Quickly get started with 

```
docker run --name somename -p 6379:6379 redis
```

## Connection

The simplest connection string is to use `localhost` which just connects to the localhost on port 6379. 

## Querying 

Redis is a really simple server to which you can just telnet (or use the redis-cli) to run commands. 

**List All Keys**

This might not be a great idea against a prod server with lots of keys

```
keys *
```

**Get key type**

Redis supports a bunch of different data primatives like a simple key value, a list, a hash, a zset, ... to find the type of a key use `type`

```
type HereForElizabethAnneSlovak
+zset
```

**Set key value**
```
set blah 7
```
This works for updates too

**Get key value**

```
get blah
```

**Get everything in a zset**

```
ZRANGE "id" 0 -1
```

**Count everything in a zset**
```
zcount HereForjohnrufuscolginjr. -inf +inf
```

**Get the first thing in a zset**

```
ZRANGE "id" 0 0
```

**Get everything in a set**

```
SMEMBERS HereFeedHashTags
```