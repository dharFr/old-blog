---
layout: post
title: "Some fun with git hooks and grunt.js"
date: 2012-07-23 22:55
comments: true
categories: 
 - Automation
 - git
 - grunt.js
---
Before going further, I'll start by saying that I'm a Git and Github noob, so if you have a better solution to achieve the same goal, give me a shout, I'll be happy to hear it..!


A few weeks ago, I implemented a small bookmarklet to apply [google-code-prettify](https://code.google.com/p/google-code-prettify/) anywhere on the Web.
I put the source code [on Github](https://github.com/dharFr/prettyprint-bookmarklet) and used the (_awesome_) [Automatic Page Generator](https://help.github.com/articles/creating-pages-with-the-automatic-generator) to quickly create a landing page to host my bookmarklet.

The generated page lives on the same repository, on a branch called `gh-pages`.
At this point, my concern was the following: How could I include the bookmarklet link on `gh-pages` branch from the source code living on the `master`?

<!-- more -->

## Basic workflow (handmade™)

In a first try, I could just copy/paste the minified source into an `<a href="...">` link in my `index.html`.
But what happens if I update the source?
I'll probably have to deal with that kind of work flow:

``` sh
grunt # lint, concat and minifies source
git add .
git commit -m "Probably improved something in there"

# copy content from dist/prettyprinter.min.js

git checkout gh-pages # checkout gh-pages branch

# paste code somewhere into index.html (without)

git add .
git commit -m "Updated landing page with latest bookmarklet version"

git checkout master # back to master branch

```
Rather boring, right? Totally agree! And that's why I decided to dig a little further to see how I could automate this.


## Avoiding copy / paste

Copy/paste a file from a branch to another _may_ be acceptable if you do it only once. From there, it's probably better to use the following: 

```
git checkout gh-pages # checkout gh-pages branch

# add/update 'dist' directory from master branch
git checkout master -- dist  
```

## Updating HTML content

As mentioned earlier, I already used [grunt.js](http://gruntjs.com/) to lint, concat and minify my source on the `master` branch. 
So I searched for a way to use grunt to update the HTML link. I quickly found [grunt-replace](https://github.com/outaTiME/grunt-replace), perfect fit for the job.
I ended up with an HTML source file, with a placeholder for the bookmarklet: 
``` html
<a href='@@bookmarklet'>Prettify</a>
```
And a simple grunt `replace` task, reading the minified source and generating an up-to-date `index.html`
``` js
  grunt.initConfig({
    replace: {
      dist: {
        src: ['src/index.html'],
        dest: '',
        variables: {
          bookmarklet: '<%= grunt.file.read(\'dist/prettyprinter.min.js\') %>'
        }
      }
    }
  });
```

## Automate the whole thing: Introducing git hooks

------------

## References

 - [Easily keep gh-pages in sync with master](http://lea.verou.me/2011/10/easily-keep-gh-pages-in-sync-with-master/) by Lea Verou
 - [Github Pages Workflow](http://oli.jp/2011/github-pages-workflow/) by by Oli Studholme
 - [Git post-commit hook to keep master and gh-pages branch in sync](http://get.inject.io/n/XxsZ6RE7)





