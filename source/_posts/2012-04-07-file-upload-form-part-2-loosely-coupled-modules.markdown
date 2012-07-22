---
layout: post
title: "File Upload Form - Part 2: Loosely Coupled Modules"
date: 2012-04-07 17:48
comments: true
published: false
categories: 
- Javascript
- Progressive Enhancement
- Feature Detection
- Loosely Coupled Modules
- Forms
---

In this post, I'll continue to work on the code started in the first article on [Feature Detection and File Upload Forms](/blog/2012/03/24/file-upload-form-part-1-feature-detection/), so you'd better read it before going further.

Last time, we created a Javascript module used to upload a file asynchronously on the server.
It uses `FormData` and `FileList` APIs in modern browsers but also degrades gracefully with browsers that don't support those APIs.

This time, I'll explain how to handle the thumbnail associated to the file input field.
It's a good example to introduce _loosely coupled modules_, and to show some other uses of the _feature detection_ technique.

As mentioned in the previous post, you can find the source code on Github: [uploader-thumbnail](https://github.com/dharFr/uploader-thumbnail/).

### Loosely Coupled Modules

If you never hear about loosely coupled module, I highly recommended you to read/watch the following:

- Nicholas Zakas' talk on [Scalable JavaScript Application Architecture](http://www.youtube.com/watch?v=vXjVFPosQHw) [YouTube]
- Addy Osmani's [Patterns For Large-Scale JavaScript Application Architecture](http://addyosmani.com/largescalejavascript/)

<!-- more -->

Those links will give you a pretty good picture but to summarize briefly, the main  concepts to keep in mind when you want to rely on a _loosely coupled modules_ architecture is that you need to: 

 - Split your code into separate modules, obviously.
 - Don't allow a module to know about each-other.

How could you do that? Let's try to illustrate the idea with our file upload form.

### Creating modules

We will create three simple modules to complete our file upload form, each one related to a very simple functionality:

 - 1st Module `uploader`: uploads a file
 - 2nd Module `remover`: ask for deleting a previously uploaded file
 - 3rd Module `thumbnail`: display a thumbnail

In [the first part](/blog/2012/03/24/file-upload-form-part-1-feature-detection/) we have already build the first one. As the two other ones are quite easy to implement, I won't detail every piece of code in this post. Feel free to look at the [complete source](https://github.com/dharFr/uploader-thumbnail/) if necessary. For now let's see those two as black boxes that fits with our requirements.

### Communication between modules: introducing the observer

As mentioned before, our modules can't reference each-other. In other words, in the `uploader`'s code, calling a method from the `thumbnail` object or referring to it in any other way is forbidden.

``` js
    // uploader's inside code
    thumbnail.display(picture) // <-- WRONG!
```

### Adding the observer

The first step to build a Javascript application based on loosely coupled modules is to allow module to communicate between each other. Remember it's forbidden to directly reference a module from another. 





