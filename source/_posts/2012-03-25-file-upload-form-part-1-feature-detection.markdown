---
layout: post
title: "File Upload Form - Part 1: Feature Detection"
date: 2012-03-24 16:55
comments: true
categories: 
- Javascript
- Progressive Enhancement
- Feature Detection
- Forms
---

Last Thursday, I gave a talk at [@JSSophia](http://www.twitter.com/jssophia), the local Javascript User Group I co-founded with [@FredGuillaume](http://www.twitter.com/FredGuillaume).
The group is just starting (2nd meeting), so there were only a few people, but as some of them looked quite interested by my talk, and some other couldn't come due to personal or professional duties, I thought I could write a couple of blog posts about the same topic.

I choose _File Upload Form_ example because it's standalone, frequently used and it can be improved by many ways with HTML5 APIs.
It's a good example to introduce some very important Javascript concepts: 

1. Using **feature detection** for **progressive enhancement**
2. Using **loosely coupled modules** to architecture web applications.

This post focus on the first part of the talk.
It presents the _feature detection_ technique.
I'll cover the second part, _loosely coupled modules_, in another article.

If you're in a hurry, or simply don't want to read the whole post, you'll find the slides embedded below and everything else on Github:

- The final [uploader-thumbnail](https://github.com/dharFr/uploader-thumbnail/) source code.
- The [step by step demo](https://github.com/dharFr/uploader-thumbnail/tree/step-by-step-demo) I used during the talk.
- The [slides](https://github.com/dharFr/uploader-thumbnail/tree/slides).

The talk was in French so the slides are also written in French, even if it uses a lot of English keywords.

<div class="dhar-style-embedder">
	<style>
		.clearfix { clear:both; }
		div.keep-aspect-ratio { max-width:600px;margin:0 auto; }
		div.keep-aspect-ratio > div { border:0;padding:0;margin:0;position:relative; }
		div.keep-aspect-ratio > div > img { border:0;padding:0;margin:0;z-index:-1000;position:relative;top:0;bottom:0;left:0;width:100%;display:block; }
		div.keep-aspect-ratio > div > div { border:0;padding:0;margin:0;position:absolute;top:0;bottom:0;left:0;width:100%;overflow:auto;}
	</style>
	<div class="keep-aspect-ratio">
	<div><img src="/assets/dhar/aspect-ratio-4-3.png" /><div>
	<iframe src="/assets/slides/embedder.html#uploader-thumbnail/slides.html" frameborder="0" width="100%" height="95%"></iframe>
	</div></div><div class="clearfix"></div>
	</div>
</div>

<!-- more -->

### Initial Markup

The main idea in progressive enhancement is to provide an application that work in any context.
A good approach is to start development with features that will work (quite) everywhere, and _progressively_ add more specific features to improve your application's user experience in modern browsers.

Talking about _file upload form_, our starting point is a simple HTML markup.

``` html Initial Markup https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/views/upload.ejs Source
	<form id="upload-form" action="" method="post" enctype="multipart/form-data">
		
		<label for="upload">Go Upload Something</label><br>

		<input type="hidden" name="fileId" value="12345">
		<input type="file" name="upload" id="upload" accept="image/*">
		<input type="submit" value="Upload">
	</form>
```

It's simple, works in every browser and, assuming the server behind do his job, it works without a single line of Javascript.
On the other hand, it requires a full page reload so the first thing to do to bring some _hype_ in this is to allow uploading the file with an asynchronous request. 

### Feature detection

Uploading a file trough an asynchronous request isn't that easy.
The [FormData](https://developer.mozilla.org/en/DOM/XMLHttpRequest/FormData) API perfectly fits our needs but it's not well supported across all browsers (IE, I'm looking at you... See [Browser_compatibility](https://developer.mozilla.org/en/DOM/XMLHttpRequest/FormData#Browser compatibility) section).

Remember that our main concern is to provide the best user experience on each browser.
So how do we upload a file _asynchronously_ in a browser that don't support `FormData` API?
Answer is by using an `iframe`. 

#### iframe file upload

Please note that I started by creating a jQuery plugin to make the code more easily reusable.
I also hid the submit button and the bound event 'onchange' on the input field to submit the form.
The following code snippets come from [step1/upload.js](https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step1/upload.js) file.

First, we have to listen to the `submit` event to prepare the form:

``` javascript form submit event listener https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step1/upload.js#L26-31 Source
	this.$form.on('submit.uploader', $.proxy(function(){

		// old-school iframe method
		this.prepareIframeUpload();
		return true; // submit the form
	}, this));
```

Next, let's append an hidden `iframe` to the form and define the `target` attribute to match the `iframe` id.
Once done, the form can be submitted as usual, the server's answer will be loaded into the `iframe`. 

However, due to security concerns, we won't be able to read the `iframe` content once loaded, so we also need to create a callback function and to send the function name to the server as a URL parameter.
This way, the server script will be aware that we are using an `iframe` and will be able to generate the appropriate response.

``` javascript iframe upload https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step1/upload.js#L47-80 Source
prepareIframeUpload: function() {

	var id, cb, iframe, url;

	// Generating a random id to identify
	// both the iframe and the callback function
	this.id = Math.floor(Math.random() * 1000);
	id = "uploader-frame-" + this.id;
	cb = "uploader-cb-" + this.id;

	// creating iframe and callback
	iframe = $('<iframe id="'+id+'" name="'+id+'" style="display:none;">');
	url = this.$form.attr('action');

	this.$form
		.attr('target', id)
		.append(iframe)
		.attr('action', url + '?iframe=' + cb);

	// defining callback
	window[cb] = $.proxy(function(data) {
		console.log('received callback:', data);

		// removing iframe
		iframe.remove();
		this.$form.removeAttr('target');

		// removing callback
		this.$form.attr('action', url);
		window[cb] = undefined;

		this.onUploadDone(data);
	}, this);
},
```
Knowing that the server response will be loaded as `iframe` content, the server script has to generate this small piece of HTML.
It includes a `script` tag, witch calls the `callback` function on the parent window. The json `result` is send as a parameter of that function.

``` html server response https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/views/upload-iframe.ejs Source
	<script type="text/javascript">
	window.top.window['<%- callback %>'](<%- result %>);
	</script>
```

Here we are.
Our script can send files asynchronously, without reloading the whole page, and it even works with old browsers.
Of course, we could decide to stop there, but we won't because of the following:

- No Error handling: if something goes wrong while sending the file, or if the server don't render the good response, the callback function will never be called, and we can't handle the error.
You probably want to add a timeout to the script above to avoid waiting for an answer that would never come.
- It's not AJAX.
You probably already notice this point.
We are faking it.
The form is still sent as HTML form, we only changed his target.
The file is uploaded asynchronously, but without any XmlHttpRequest involved.
- It's dirty.
I'm OK as it stays a fall-back solution, but keeping it as the main implementation? Yuck!

#### FormData file upload

Time to do things the right way? OK. Let's start by editing the submit event listener as following:

``` javascript updated submit event listener https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step2/upload.js#L26-46 Source
	this.$form.on('submit.uploader', $.proxy(function(){

		var file = false
		if (this.$upload[0].files) file = this.$upload[0].files[0];

		this.beforeUpload(file);

		if (window.FormData && file ) {

			console.log('FormData supported and file is:', file);
			this.upload(file);
			return false;
		}
		// fallback to old-school iframe method
		else {
			console.log('FormData is not supported or file is undefined:', file);
			this.prepareIframeUpload();
			return true; // submit the form
		}

	}, this));
```


The `this.$upload` variable represents a jQuery object containing the `input[type=file]` DOM node (see the complete [step2/upload.js](https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step2/upload.js) file for more details).
Here we have to check if the browser supports both `File` and `FormData` APIs.
If these two conditions are satisfied, we can go with the _"HTML5"_ file upload.
Otherwise, we just fall-back to the `iframe` hack... Simple isn't it? 

This is **Feature Dectection** and it's one of the **key concepts of modern web development**.
It's the only way we have to use the latest HTML5 features without breaking old browser's support.

Now, we're sure that we can use `FormData` upload, we just need to implement the method as shown in the following code extract.
As you can read, it's way simpler and less hacky compared to the `iframe` method.
Server response and errors are handled the same way than with any other ajax request. 

``` javascript FormData upload https://github.com/dharFr/uploader-thumbnail/blob/step-by-step-demo/public/js/step2/upload.js#L61-80 Source
	upload: function(file) {

		var formdata = new FormData(this.$form[0]);

		if (formdata) {
			var jqXhr = $.ajax({
				url: this.$form.attr('action'),
				type: this.$form.attr('method'),
				data: formdata,
				// tells jQuery not to prepare data before sending the request
				processData: false, 
				contentType: false
			});

			jqXhr
				.done($.proxy(this.onUploadDone, this))
				.fail(function(){
					console.log("upload error:", arguments);
				});
		}
	},
```

We're done for part 1.
Our upload form is fully functional for both modern and old browsers, and even with Javascript disabled.
In the 2nd part, I explain how to handle the thumbnail associated to the file input field.
It's a very good example to introduce _loosely coupled modules_, and to show some other uses of the _feature detection_ technique.
[File Upload Form - Part 2: Loosely Coupled Modules](/blog/2012/04/07/file-upload-form-part-2-loosely-coupled-modules/)


### References:

- [Browser detection using the user agent](https://developer.mozilla.org/en/Browser_detection_using_the_user_agent) on MDC
- [FormData](https://developer.mozilla.org/en/DOM/XMLHttpRequest/FormData) API
- [FileList](https://developer.mozilla.org/en/DOM/FileList) API





