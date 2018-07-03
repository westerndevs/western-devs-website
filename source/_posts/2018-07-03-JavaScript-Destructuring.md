---
layout: post
title: Weird JavaScript - Destructuring 
authorId: simon_timms
date: 2018-07-02
---

I've been at this programming game for a long time and I've written two books on JavaScript. Still today I ran into some code that had me scratching my head. It looked like 

```javascript
function AppliedRoute ({ component: C, props: cProps, ...rest }) {
```

I was converting some JavaScript to TypeScript and this line threw an linting error because of `implicit any`. That means that the type being passed in has no associated type information and has been assumed to be of type `any`. This is something we'd like to avoid. Problem was I had no idea what this thing was. It looked like an object but it was being built in the parameters?  

<!-- more -->

Well turns out that after some digging this was a form of JavaScript destructuring. Destructuring means taking an object or an array and extracting values from it into variables. In this weird case we were passing some object into this function and stripping off variables called C, cProps and rest. C was being bound to the field `component`, cProps to the field `props` and then all the rest of the values in the object were being assigned to an object called `rest`. Destructuring is a powerful tool but if you haven't seen the syntax before (this guy right here) then it is confusing as heck. The ever interesting Dr. Axel Rauschmayer has a fantastic article on it over at [http://2ality.com/2015/01/es6-destructuring.html](http://2ality.com/2015/01/es6-destructuring.html) which is well worth a read if you want to avoid my confusion. 

As for the conversion to TypeScript the solution could be as simple as 

```javascript
function AppliedRoute ({ component: C, props: cProps, ...rest }: any) {
```

Or it could involve creating a strong type to annotate what's being passed into the function. I opted for the former because in this case what was being passed in could take many shapes. 