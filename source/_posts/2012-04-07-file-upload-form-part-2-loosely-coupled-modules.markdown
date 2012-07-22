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

If you never ear about loosely coupled module, I highly recommended you to read/watch the following:

- Nicholas Zakas' talk on [Scalable JavaScript Application Architecture](http://www.youtube.com/watch?v=vXjVFPosQHw) [YouTube]
- Addy Osmani's [Patterns For Large-Scale JavaScript Application Architecture](http://addyosmani.com/largescalejavascript/)



### Adding the observer

The first step to build an Javascript application based on loosely coupled modules is to add 





