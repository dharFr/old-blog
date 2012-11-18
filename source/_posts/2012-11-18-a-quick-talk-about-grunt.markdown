---
layout: post
title: "A quick talk about Grunt"
date: 2012-10-28 00:24
comments: true
categories: 
 - grunt.js
 - tools

status: draft
published: false
---


A few weeks ago, a gave a quick talk about [Grunt][grunt] at [@JSSophia][jssophia], our local Javascript User Group.
During this talk, my purpose was to quickly present the tool and show some example use cases.
I must confess I wasn't as prepared as I would have been, so my talk may have been confused or unclear from time to time. 
If you attended the event, I hope this post will give you more details.
If not, it doesn't matter, I'm still happy to share my thoughts about this amazing tool.


You'll find the slides bellow.
The first part mostly present _Grunt_ and why I think it's a game-changer for front-end developers. As I already wrote about this in my [previous post about Grunt][previouspost], I invite you to read it if it sounds interesting to you.
In the second part, I focused on showing a few examples use cases and concrete examples. 
That's what I'm going to detail in this post.

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
  <iframe src="/assets/slides/embedder.html#grunt/template.html" frameborder="0" width="100%" height="95%"></iframe>
  </div></div><div class="clearfix"></div>
  </div>
</div>

<!-- more -->

## Automating your web application

Bringing some automation to your web-application is probably the first thing you'll try with Grunt. 
After all, that's its first purpose, why it was designed for.

Because nothing worth an example, I reused an old project to illustrate this case.
It's a simple Gallery application build over Backbone.JS, jQuery, QUnit and Twitter Bootstrap.
The full project is available [on Github][gallery].
The code I used as an example lives in the _master_ branch.
The original code, as it was before adding Grunt, lives in the [before-grunt][gallery-bg] branch.

### Adding Grunt to an existing project

Assuming Grunt is already [installed][install-grunt] on your system, adding Grunt to your project is as simple as typing the following in your terminal:

``` bash 
> cd /path/to/your/project/
> grunt init:gruntfile 
```

After answering a few question, this will produce a single `grunt.js` file in your project's folder.
The basic structure of a gruntfile is looks like this: 

``` js grunt file basic structure
/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // ...
    taskName: {
      // task properties
    },
    // ...
  });
};
```

We are working with a web-application, so most of the tasks we need are already included in grunt.
What do we basically need ?

 * _lint_ javascript files
 * run _qunit_ unit tests
 * _concat_ and _minify_ javascript files

In addition, it would be interesting to:

 * run _qunit_ tests again on the minified `js` files to check if anything is broken in the process
 * _copy_ assets (`css`, pictures, etc.) to a build folder in order to have a standalone built version of the application 
 * create an alternative version of the `html` files containing minified `js` files rather than development files



### Setting up your tasks

Lint, QUnit, concatenation and minification tasks are already built in Grunt. It won't be too difficult to define these for our project.
If you need another task, start by searching if an existing `grunt-plugin` have already been created by the community.
You can search for an existing plugin on [grunt homepage][grunt] or directly with npm: 

``` bash Searching for grunt plugins on NPM
# Search for a grunt plugin to do some magic:
> npm search gruntplugin 'do magic'
```

Otherwise, you can define your own task using the [Grunt API][grunt-api], but unless you need something very specific, I doubt you had to go there. 
Seriously, there are already 190 existing plugins at the time I write these lines.

Once you've found and installed the plugin you need, you still have to made it available in your `gruntfile` by using the `loadNpmTasks` api.
In our case, we'll need two external tasks:


``` js Loading external tasks https://github.com/dharFr/gallery/blob/master/grunt.js#L125-126 source
  // ...
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-targethtml');
  // ...
```

From there, we just need to configure our tasks.
I'm not going to detail every single line in the resulting `gruntfile` bellow.
Basically, it allows us to build (lint, concat and minify) javascript files, copy any other files to a `dist` folder, and run the tests on both `dev` and `dist` files.
The syntax is quite self-explaining and you can always refer to the [official documentation][grunt-doc] is needed.


``` js Extract from Gallery Gruntfile https://github.com/dharFr/gallery/blob/master/grunt.js source
/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    // read some data from package.json file
    pkg: '<json:package.json>',
    // Defines project's meta data
    // the banner is used by minification task and 
    // will be at the beginning of each processed file
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    // Defines a custom config property.
    // This property '<%= build.dest %>'
    build: {
      dest: 'dist'
    },
    // lint task
    // Defines witch files to lint
    lint: {
      files: ['grunt.js', 'js/gallery/**/*.js', 'tests/js/**/*.js']
    },
    // qunit multi-task
    // Defines 2 different targets
    // (dev, dist) for running qunit.
    // Each target defines a list of test files
    qunit: {
      dev: ['tests/index.html'],
      dist: ['<%= build.dest %>/tests/index.html']
    },
    // concat multi-task
    // Defines 3 different targets 
    // (libs, tests, dist) for concatenation.
    // Each target defines a list of files to concatenate
    // and a destination file to write the output
    concat: { 
      libs: {
        src: [ "js/libs/json2.js", "js/libs/jquery-1.8.2.min.js", "js/libs/mustache-0.7.js", "js/libs/underscore-1.4.1.min.js", "js/libs/backbone-0.9.2.min.js" ],
        dest: '<%= build.dest %>/js/libs/<%= pkg.name %>-libs.<%= pkg.version %>.js'
      },
      tests: {
        src: [
          '<banner:meta.banner>', 'js/gallery/config.js', 'js/gallery/models/gallery.js', 'js/gallery/views/header.js', 'js/gallery/views/main-image.js', 'js/gallery/views/thumbnails.js', 'js/gallery/views/gallery.js' ],
        dest: '<%= build.dest %>/tests/js/<%= pkg.name %>-tests.<%= pkg.version %>.js'
      },
      dist: {
        src: [
          '<banner:meta.banner>', 'js/gallery/config.js', 'js/gallery/models/gallery.js', 'js/gallery/views/header.js', 'js/gallery/views/main-image.js', 'js/gallery/views/thumbnails.js', 'js/gallery/views/gallery.js', 'js/gallery/app.js' ],
        dest: '<%= build.dest %>/js/<%= pkg.name %>-app.<%= pkg.version %>.js'
      }
    },
    // min multi-task
    // Defines 3 different targets 
    // (libs, tests, dist) for minification.
    // Each target defines a list of files to minify
    // and a destination file to write the output
    min: {
      libs: {
        src: ['<config:concat.libs.dest>'],
        dest: '<%= build.dest %>/js/libs/<%= pkg.name %>-libs.<%= pkg.version %>.min.js'
      },
      tests: {
        src: ['<banner:meta.banner>', '<config:concat.tests.dest>'],
        dest: '<%= build.dest %>/tests/js/<%= pkg.name %>-tests.<%= pkg.version %>.min.js'
      },
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: '<%= build.dest %>/js/<%= pkg.name %>-app.<%= pkg.version %>.min.js'
      }
    },
    // targethtml multi-task
    // Defines 2 different targets (release, tests) 
    // Each target defines a source file to process
    // and a destination file to write the output
    targethtml: {
      release: {
        src: 'index.html',
        dest: '<%= build.dest %>/index.html'
      },
      tests: {
        src: 'tests/index.html',
        dest: '<%= build.dest %>/tests/index.html'
      }
    },
    // copy multi-task
    // Defines 1 single target (dist) 
    // copy files from development path 
    // to 'build.dest' folder
    copy: {
      dist: {
        files: {
          "<%= build.dest %>/css/": "css/**",
          "<%= build.dest %>/img/gallery/": "img/gallery/**",
          "<%= build.dest %>/js/libs/bootstrap/": "js/libs/bootstrap/**",
          "<%= build.dest %>/tests/": ["tests/js/**", "tests/libs/**"],
          "<%= build.dest %>/gallery_data.json": "gallery_data.json"
        }
      }
    },
    // clean task
    // remove every file from the defined folders
    clean: ["<%= build.dest %>"],

    // watch task
    // runs the defined tasks every time a watched file is updated
    watch: {
      files: '<config:lint.files>',
      tasks: 'lint qunit:dev'
    },
    // ...
  });

  // Load external tasks (grunt plugins)
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-targethtml');

  // Register custom tasks (alias tasks)
  grunt.registerTask('build', 'concat min targethtml copy');
  grunt.registerTask('clean-build', 'clean concat min targethtml copy');
  // Default task.
  grunt.registerTask('default', 'lint qunit:dev build qunit:dist');
};
```

Each task can be run independently by typing `grunt taskName` in a terminal. 
Additionally, you can run a specific target on every multi-task by typing `grunt multiTaskName:targetName`.
The `registerTask` API allows us to define aliases to run a few tasks with a single command.

``` bash
# run lint task
> grunt lint

# run concat and minify tasks
> grunt concat min

# run only dev target of qunit task
> grunt qunit:dev

# run "build" alias (ie: 'grunt concat min targethtml copy')
> grunt build

# run default task (ie: 'grunt lint qunit:dev build qunit:dist')
> grunt
```



## So what's next?

I hope you already see the kind of benefits you can get by adding Grunt to your web-application projects.

I also encourage you to take a look at the plugin system, which will allow you to create your own tasks.
The well made `gruntplugin` init task (`grunt init:gruntplugin`) will bootstrap everything you need to start your own task and publish it in minutes. 
If you find yourself stucked at some point, the [Grunt API documentation][grunt-api] is a very good reference.
You can also check the source code of one of the official plugins on github.

As I wrote at the beginning of this post, using Grunt to automate some tasks in your web-application projects is probably the first thing you're going to try.
But I'm convinced you can use it in many other ways.
If you need some more examples, I invite you to look at my own experiments with Grunt:

 * [static-templater][static-templater]: A grunt-based command line tool to render HMTL and PDF from JSON and HTML templates 
 * [grunt-wkhtmltopdf][grunt-wkhtmltopdf]: A simple Grunt multitask that uses wkhtmltopdf to convert HTML files to PDF.



[grunt]:            http://www.gruntjs.com "Grunt homepage"
[jssophia]:         http://www.twitter.com/jssophia "JS Sophia-Antipolis"
[previouspost]:     /blog/2012/08/26/grunt-brings-automation-to-the-front-end-side/ "Grunt Brings Automation to the Front-end Side"

[static-templater]: https://github.com/dharFr/static-templater "Static Templater"
[grunt-wkhtmltopdf]:https://github.com/dharFr/grunt-wkhtmltopdf "grunt-wkhtmltopdf"

[gallery]:          https://github.com/dharFr/gallery "Gallery App: 'master' branch"
[gallery-bg]:       https://github.com/dharFr/gallery/tree/before-grunt "Gallery App: 'before-grunt' branch"
[install-grunt]:    https://github.com/gruntjs/grunt#installing-grunt "Installing Grunt"

[grunt-api]:        https://github.com/gruntjs/grunt/blob/master/docs/api.md "Grunt API"
[grunt-doc]:        https://github.com/gruntjs/grunt/blob/master/docs/toc.md "Grunt Documentation"

