---
title:  Handling Nil in Nested Hashes in Ruby
authorId: simon_timms
date: 2021-11-24
originalurl: https://blog.simontimms.com/2021/11/24/hash_nil
mode: public
---



Tony Hoare introduced Null in ALGOL W in 1965. He says that it was a billion dollar mistake. Fortunately, Ruby totally avoids this sticky problem by renaming `null` to `nil`. This is the same strategy that my kids use when I say "next person to ask for popcorn is going to do pushups" and they ask for "corn that has been popped". If you're navigating a nested hash, that is a hash that contains other hashes then you might get into a situation where you want to do something like 

```
best_dessert = meals[:dinner][:dessert].find{ | dessert | {name: dessert.name, rating: dessert.rating } }.sort_by{ |a,b| b[:rating] }.first
```

There are a bunch of opportunities in there for nil to creep in. Maybe there are no dinners maybe no desserts... to handle these we can use a combination of `dig` (which searches a path in a hash and returns nil if the path doesn't exist) and the safe navigation `&.` operator.

```
best_dessert = meals.dig(:dinner, :dessert)&.find{ | dessert | {name: dessert.name, rating: dessert.rating } }&.sort_by{ |a,b| b[:rating] }&.first
```

This combination of dig and &. allows us to get a nil out if nil appears anywhere in the chain without ending up in an error. We are calling the combination of dig and &. the 811 operator after https://call811.com/