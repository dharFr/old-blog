---
layout: post
title: "Queued ajax requests with jQuery and Coffescript"
date: 2012-03-31 21:46
comments: true
categories:
- Coffeescript
- Javascript
- jQuery
- Deferred objects
- jQuery plugin
---

I recently had to queue a few ajax requests. I wrote a little piece of Coffeescript+jQuery to provide a reusable way of doing it. 
Using jQuery's [Deferred](http://api.jquery.com/category/deferred-object/) objects and CoffeeScript makes the task really easy. 

<!--more-->

You probably already know that all jQuery's ajax methods implement [Promise](http://api.jquery.com/Types/#Promise) interface. That's why we can use the `pipe()` method to queue the queries, as well as `done()` and `fail()` methods to track the queries' progress.

Another interesting point is how CoffeeScript make the code clearer and easy to read. I particularly enjoyed using [splats](http://jashkenas.github.com/coffee-script/#splats) (`...`) to write the `$.when(deferredObjs...)` part on line 34. Speaking about code readability, it's such an improvement compared to the `$.when.apply($, deferredObjs)` Javascript counterpart.

You can find a [working sample](http://jsfiddle.net/wA6K8/1/) on jsFiddle.

{% gist 2244946 jquery.queue.coffee %}

### References

* jQuery's [Deferred](http://api.jquery.com/category/deferred-object/) objects
* [Source code](https://gist.github.com/2244946) on gist
* [Working sample](http://jsfiddle.net/wA6K8/) on jsFiddle
