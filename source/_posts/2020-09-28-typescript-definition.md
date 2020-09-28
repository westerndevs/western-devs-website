---
layout: post
title: The trimStart rabbit hole 
authorId: simon_timms
date: 2020-09-28 14:00
originalUrl: https://blog.simontimms.com/2020/09/28/2020-09-28-typescriptd-definition/
excerpt: If you're missing expected functions in your TypeScript app the problem might be an incorrect target
---

I was bragging to [David](https://westerndevs.com/bios/dave_paquette/) about a particularly impressive piece of TypeScript code I wrote last week

```
if (body.trim().startsWith('<')) { //100% infallible xml detection
```

He, rightly, pointed out that `trimStart` would probably be more efficient. Of course it would! However when I went to make that change there was only `trim`, `trimLeft` and `trimRight` in my TypeScript auto-complete drop down. 

![TrimStart and TrimEnd are missing](https://blog.simontimms.com/images/trimStart/missing.png)

Odd. This was for sure a real function because it appears in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/trimStart).

A reasonable person would have used trimLeft and moved on but it was Monday and I was full of passion for programming. So I went down the rabbit hole. 

Checking out the TypeScript directory in my node_modules I found that there were quite a few definition files in there. These were the definition files that described the JavaScript language itself rather than any libraries. Included in that bunch was one called `lib.es2019.string.d.ts`. This file contained changes which were made to the language in es2019. 

```typescript
interface String {
    /** Removes the trailing white space and line terminator characters from a string. */
    trimEnd(): string;

    /** Removes the leading white space and line terminator characters from a string. */
    trimStart(): string;

    /** Removes the leading white space and line terminator characters from a string. */
    trimLeft(): string;

    /** Removes the trailing white space and line terminator characters from a string. */
    trimRight(): string;
}
```

So I must be targeting the wrong thing! Sure enough in my `tsconfig.js` I was targeting `es5` on this project. When we started this was using an older version of node on lambda that didn't have support for more recent versions of ES. I checked and the lambda was running node 12.18.3 and support for ES2020 landed in node 12.9 so I was good to move up to es2020 as a target.

Incidentally you can check the running node version in JavaScript by running

```
console.log('Versions: ' + JSON.stringify(process.versions));
```

After updating my `tsconfig.js` and restarting the language server all was right in the world. 

![The missing functions appear](https://blog.simontimms.com/images/trimStart/there.png)