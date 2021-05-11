---
title:  JQ
authorId: simon_timms
date: 2021-05-11
originalurl: https://blog.simontimms.com/2021/05/11/jq
mode: public
---



This is a really nice tool for manipulating JSON on the command line. The syntax is, however, esoteric like you would not believe. Here are some cheats to help out

If you have an array and want to take just the object at a specific index

```
.[3]
```
which returns the 3rd element

If you want to extract a value from an array of objects then you can use
```
.[].LicensePlate
```

This works for multiple levels too so if you have nested objects you can 

```
.[].LicensePlate.Province
```

Given an array where you want to filter it then you can use this
```
[ .[] | select( .LicensePlate | contains("PM184J")) ] 
```

To select a single field you could then do 

```
[ .[] | select( .LicensePlate | contains("PM184J")) ] |  map( .LicensePlate)
```

If you want multiple fields built back into an object do 

```
{LicensePlate: .[].LicensePlate, EndTime: .[].EndTime}
```

