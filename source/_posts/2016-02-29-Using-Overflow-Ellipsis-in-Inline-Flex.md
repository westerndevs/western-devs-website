---
layout: post
title: "Using text-overflow:ellipsis with Inline Flex"
categories:
  - css
date: 2016-02-29 15:58:40
tags:
  - html
  - css
  - flexbox
excerpt: Two out of three Dave's hit this obscure CSS problem that turned out to be expected behaviour. David Wesst walks us through the reason why and how to fix it.
authorId: david_wesst
originalurl: http://www.webnotwar.ca/opensource/using-text-overflowellipsis-with-inline-flex/
---

[Dave Paquette][1], a fellow Western Dev, hit a strange CSS snag the other day. He wanted to use the `text-overflow: ellipsis` on a flexbox item that displayed text, where the ellipsis would show up if the text was too long.

It didn't work as expected, but after some digging, a solution was discovered. This post exists to document both the problem and solution with the hope that it prevents future headaches for other CSS developers.

## The Problem

His code went something like this:

```html
<ul>
  <li class="item">
    <i>Icon</i>
    <span>Item Code 321</span>
    <span>Descriptive Text</span>
  </li>
  <li class="item">
    <i>Icon</i>
    <span>Item Code that is way too long and shoud use ellipsis</span>
    <span>Descriptive Text</span>
  </li>
  <li class="item">
    <i>Icon</i>
    <span>Item Code 123</span>
    <span>Descriptive Text</span>
  </li>
</ul>
```

```css
li span {
  display: inline-flex;
}

.item span {
  width: 100px;
  margin-left: 1em;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
```

The goal here is to have all the `<span>` elements line up, regardless of their contents. If their contents exceed the length of the `<span>` then should display an ellipsis.

This isn't the case.

Instead, you get something like this:

{% asset_img broken-result.png "Not quite right" %}

We have everything aligned, but no ellipsis. Why?

## The Solution

It turns out that this is the expected behaviour (see "But Why?" section below).

The solution is to make sure that we apply the `text-overflow` property to a block element that lives inside a flex item. In our case, we need to wrap the text we want to have the ellipsis show up in a block element.

The working code looks like this:

```html
<ul>
  <li class="item">
    <i>Icon</i>
    <span>
        <div>
          Item Code 321
        </div>
    </span>
    <span>Descriptive Text</span>
  </li>
  <li class="item">
    <i>Icon</i>
    <span>
        <div>
          Item Code that is way too long and shoud use ellipsis
        </div>
    </span>
    <span>Descriptive Text</span>
  </li>
  <li class="item">
    <i>Icon</i>
    <span>
        <div>
          Item Code 123
        </div>
    </span>
    <span>Descriptive Text</span>
  </li>
</ul>
```

```css
.item span {
  display: inline-flex;
}

.item span {
  width: 100px;
  margin-left: 1em;
  white-space: nowrap;
}

.item span div {
  overflow: hidden;
  text-overflow: ellipsis;
}
```

The `<div>` we introduce is a block element that lives inside of the flex item. Now the `text-overflow` property applies, and all is good!

{% asset_img working-result.png "It Works!" %}

### The Solution in Action

In case you want to see the end result working, here you&nbsp;can check it out [here][4].

<script async src="https://jsfiddle.net/davidwesst/fhkt9mco/5/embed/html,css,result/"></script>

## But Why?

I'll try and explain this, but be aware that I'm likely oversimplifying things.

As I mentioned before, this whole issue is expected behaviour. If you look at [the spec][5] for,&nbsp;`text-overflow` you find the definition you see in the quote below

This property specifies rendering when inline content overflows its line box edge in the inline progression direction of its block container element ("the block") that has overflow other than visible.

It turns out `text-overflow` isn't meant to work on flex items, rather it is meant to work on block items as per the spec.

That being said, so what? I mean, can't the spec be adjusted to include `text-overflow` on flex items? Although you would think it's not a big deal to make this work for flex-items too, there are a number of considerations that need to be taken into account. More specifically, how flexbox works.

It turns out that there really isn't a clean way to do this. If you're wondering how I came to that conclusion you can stop because I didn't. Those responsible for the specification did, and you can read the full conversation that started with a [Mozilla bug report][6] and leads to a whole [mail group discussion][7] about why it should (or, in this case, should not) be implemented as part of the spec.

And that, ladies and gentlemen, is how you get `text-overflow` working on flex items. You don't. :)

[1]: http://www.westerndevs.com/bios/dave_paquette/
[4]: https://jsfiddle.net/davidwesst/fhkt9mco/5/embed/html,css,result
[5]: https://drafts.csswg.org/css-ui/#text-overflow
[6]: https://bugzilla.mozilla.org/show_bug.cgi?id=912434
[7]: http://lists.w3.org/Archives/Public/www-style/2013Sep/0070.html
