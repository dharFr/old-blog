---
layout: post
title: "Grunt brings automation to the front-end side"
date: 2012-08-26 16:26
comments: true
categories: 
 - Automation
 - grunt.js
 - tools
---

Over the past few weeks, I realized that I added [grunt][grunt] in every little side project I worked on.
Thinking about it, I'm not sure if I can even imagine to start a project without this tool. 

You probably already heard about **grunt**, don't you? In case you don't (seriously?), it's been created by [Ben Alman (aka. cowboy)](http://benalman.com/).
I guess the best description is the one from the official home page:

> Grunt is a task-based command line build tool for JavaScript projects.

OK, looks nice.
But what's new? 
I already have tools to _lint_ or _minify_ my Javascript.
I already use _qunit_ to unit test my code.
And so on... Why should I use _grunt_ instead of all these tools?

Here is why:

1. Because you probably don't really use all these tools. 
I mean, for sure you know about them, and you already give them a try; but most people I worked with (including me) just don't use them on real projects, in their day to day work, because bringing the pieces together is not that easy. 
2. _Grunt_ also uses the exact same tools you already know, or in the worst case, it can learn to use them.
It doesn't reinvent anything but allows you to organize your workflow in an uniform, yet flexible, way.

[grunt]: http://www.gruntjs.com (Grunt)

## Do we need such a tool?

As a front-end developer, automation wasn't really part of my workflow. 
My first job was in some king of web agency were every desktop machine ran on Windows XP, and our main development tools were Dreamweaver MX (I guess I'm getting old...) and Filezilla. <!-- more -->
At the time we would never have considered automation, unit testing or continuous integration.

Then I left that company and found a real engineer job. 
But still, like many other developers, I relied on some kind of heavy IDE where every _low level_ interaction with the OS tend to be hidden. 
And I never really felt a need to dig into this.
Until recently, I was convinced _automation_ was only a concern for back-end or system engineers.

## Everything you need is a terminal!

On the other hand, a lot of _front-end_ tools came up recently, especially since _Node.js_ brought Javascript to the Terminal but not only. 
**Uglify-js**, **JSLint**, **Qunit**, **Jasmine**, **CoffeeScript**, **SASS**, **LESS** are only the most famous but there are many others. 
These tools are changing our approach to front-end technologies, they make us more productive, adding value to our jobs.

But those tools remains _command line tools_. 
Even if each one of them is pretty simple to setup and use, combining all of these to make something adapted to a particular project can quickly become a nightmare for someone who's not familiar with his Terminal.
From my experience, a lot of front-end developers, especially younger ones, are not familiar with Bash scripting (_and sometimes are afraid of it_). For sure, that's probably a bad approach, but that's how I felt not that long ago and I'm pretty sure I'm not the only one in that case.

Grails developers write their scripts in Groovy.
Rails developers have Rake files.
**We know how to write Javascript!** That's where we are comfortable and productive.
We don't want to get a headache by writing some messy _bash_ script <sup>\[[1](#note1)\]</sup>.

## Here comes grunt

That's what _grunt_ does. It allows you to define a bunch of tasks, in a **consistent way**, by writing Javascript.
_Consistent_ is an important word here because you could probably achieve the same goal directly with _Node.js_ but _grunt_ gives you a simple way to write and organize your tasks. 
The most common ones (_lint_, _concat_, _minify_, _test_, etc.) are already included [in the package][grunt-built-in] so you don't have to think about how to deal with them. 

It also came with a really simple [plugin system][grunt-plugins] based on [npm][npm].
If you find yourself needing to do something not included as a build-in task, try to search _npm_ to see if somebody else has not already released a plugin that fits your needs. 
Otherwise, you can still write your own plugin and publish it to _npm_.
The [grunt API][grunt-api] allows you to do pretty much everything you could need. 
And thanks to the built-in project scaffolding, it only takes a few minutes to change your spaghetti code into a well written plugin. Once here, publishing to npm is just a command line away so do not hesitate.

## What's next?

I hope you will give a try to _grunt_. Even more because something called [Yeoman](http://yeoman.io/) is getting close to the public release. I asked for a beta invite on twitter but for now, I didn't have a chance to try it yet.
It seems that it can do many more and as it's based on _grunt_, among many others, it's probably a good idea to get familiar with that one as soon as possible. 

[grunt-built-in]: https://github.com/cowboy/grunt#built-in-tasks (grunt built-in Tasks)
[grunt-plugins]: https://github.com/cowboy/grunt/blob/master/docs/getting_started.md#loading-grunt-plugins-or-tasks-folders (Loading grunt plugins or tasks folders)
[npm]: https://npmjs.org (Node Packaged Modules)
[grunt-api]: https://github.com/cowboy/grunt/blob/master/docs/api.md (The grunt API)

<a id="note1"></a>
<small>[1]: I actually did a lot of bash scripting recently and, believe it or not, I liked it. I wouldn't have said that a few years ago. It's a powerful programming tool and every developer should be comfortable with it. You're not? Learn some basics. ;)</small>
