---
layout: post
title: "File Upload Form - Part 2: Loosely Coupled Modules"
date: 2012-04-07 17:48
comments: true
categories: 
- Javascript
- Progressive Enhancement
- Feature Detection
- Loosely Coupled Modules
- Forms
---

In this post, I'll continue to work on the code started in the first article on [Feature Detection and File Upload Forms](/blog/2012/03/24/file-upload-form-part-1-feature-detection/), so you'd better read it before going further.

Last time, we created a Javascript component used to upload a file asynchronously on the server.
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


#### The Observer Pattern

As mentioned before, our modules can't reference each-other. In other words, in the `uploader`'s code, calling a method from the `thumbnail` object or referring to it in any other way is forbidden.

``` js
    // uploader's inside code
    thumbnail.display(picture) // <-- WRONG!
```
That's why we need to introduce the observer component. Its role is to allow communication between modules. In other words, instead of talking directly to each-others, modules in your application will talk and listen to the observer.

There many different implementations of the observer pattern but it's basically a component with 3 methods:
``` js
    var observer = {
      publish: function( topic ) { 
        // ...
      },
      subscribe: function ( topic, func ) {
        // ...
      },
      unsubscribe: function ( topic, func ) {
        // ...
      }
    }
```

 - `observer.publish('some-topic', message)`: send a message on the topic 'some-topic'
 - `observer.subscribe('some-topic', callbackFunc)`: starts listening messages on the topic 'some-topic'. `callbackFunc` will be called every times a message is published on the topic, the `message` will be passed as a parameter.
 - `observer.publish('some-topic', callbackFunc)`: stops listening messages on the topics 'some-topic'.

#### Using the observer

Back the the upload form, the implementation doesn't change that much. You only need to pass the observer as parameter, and publish some events to notify the application 

``` javascript adding the observer https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step3/upload.js#L13 Source
    this.obs = options.observer || {publish:function(){}, subscribe:function(){}};
```

``` javascript notifying the observer https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step3/upload.js#L132-144 Source
    beforeUpload: function(file) {
      this.obs.publish('submit.uploader', this.fileId, file);
    },

    onUploadDone: function(data) {

      // ...
      this.obs.publish('uploaded.uploader', this.fileId, this.data);
    }
```

On the other side, the thumbnail module need to listen to these events and to react to these in an appropriate way. In our case, when receiving a `submit` event, the thumbnail module should hide an existing image and display a load indicator. When receiving a `uploaded` event, it have to show the newly uploaded picture.

``` javascript listening to the observer https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step3/thumbnail.js#L19-31 Source
    Thumbnail.prototype = {
      init: function() {
        // ...

        // Observe uploader events
        this.obs.subscribe('submit.uploader', $.proxy(this.onUploadStart, this));
        this.obs.subscribe('uploaded.uploader', $.proxy(this.onUploadDone, this));

        return this;
      },
      // ...
    }
```
As you can see in the above code, both `uploader` and `thumbnail` module are not aware from each others, they only talk and listen to the observer. 

### Conclusion

 - You mat decide to completely change some module implementation, as long as it sends the same messages to the observer, everything is fine.
 - Every other module in your application can listen to observer. The thumbnail may not be the only piece of application interested in `uploader` events. That's fine, the new module just need to subscribe the appropriate event.
 - Last but not least, if some module appears to be broken, or if it doesn't starts as expected, other modules won't be much affected and your application is still working (even if some features are down).


