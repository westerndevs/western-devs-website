---
layout: post
title: Creating a Custom Matcher for TS-Mokito
tags:
  - javascript
  - testing
categories:
  - development
authorId: simon_timms
date: 2017-09-29 19:36:36
excerpt: Mocking libraries can be useful, even in JavaScript testing. One of my favorites is ts-mokito a TypeScript mocking library. One minor problem with it is that it is lacking a good array matcher. In this article we'll see how to fix that. 
---

For better or worse I've been working with a lot of Angular as of late. One of the better tools I've found for helping out with testing is a great little mocking library called [ts-mokito](https://github.com/NagRock/ts-mockito). I don't want to get into why I still like to have a mocking library even with a language like JavaScript - that's another post. 

Testing today I ran into an annoying problem in that I was testing an angular route like so 

```js
verify(mockRouter.navigate(['/some/route'])).called();
```

This test was always failing. This is because the argument to navigate is an array and in JavaScript 

```js
['/some/route'] !== ['/some/route']
```

How unfortunate. Fortunately there isn't much to a custom matcher in ts-mokito. You can already do 

```typescript
verify(mockRouter.navigate(anything())).called();
```

To simply check that something was passed in but we'd like our tests to be a bit more robust than that. Enter the ArraryMatcher

```typescript
import * as _ from 'lodash';
import { Matcher } from 'ts-mockito/lib/matcher/type/Matcher';

export class ArrayMatcher extends Matcher {
    private value: any;
    constructor(private expected) {
        super();
    }

    match(value: any): boolean {
        return _.isEqual(this.expected, value);
    }

    toString(): string {
        return `Did not match ${this.expected}`;
    }
}
```

As you can see it has an implementation of the `match` function which uses the `isEqual` from lodash. This class can be substituted into our verify 

```typescript
verify(mockRouter.navigate(<any>new ArrayMatcher(['/some/route'])).called();
```

That's a bit ugly with casting in there. This can be fixed by exporting a function from the ArrayMatcher

```typescript
export function arrayMatches(expected): any { 
    return new ArrayMatcher(expected); 
}
```

Which allows for the much more pleasant syntax

```typescript
verify(mockRouter.navigate(arrayMatches([`/some/route`]))).called();
```

Easily done and it should be simple to implement any other sort of matcher you like.