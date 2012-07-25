---
layout: post
title: "Some fun with git hooks and Grunt.js"
date: 2012-07-23 22:55
comments: true
categories: 
 - Automation
 - git hooks
 - git
 - grunt.js
---
Before going further, I'll start by saying that I'm a Git and Github noob, so if you have a better solution to achieve the same goal, give me a shout, I'll be happy to hear it..!


A few weeks ago, I implemented a small bookmarklet to apply [google-code-prettify](https://code.google.com/p/google-code-prettify/) anywhere on the Web.
I put the source code [on Github](https://github.com/dharFr/prettyprint-bookmarklet) and used the (_awesome_) [Automatic Page Generator](https://help.github.com/articles/creating-pages-with-the-automatic-generator) to quickly create a landing page to host my bookmarklet.

The generated page lives on the same repository, on a branch called `gh-pages`.
At this point, my concern was the following: How could I include the bookmarklet link on `gh-pages` branch from the source code living on the `master`?

<!-- more -->

## Basic (handmade™) workflow 

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

## Automate the whole thing!

### Avoiding copy / paste

Copy/paste a file from a branch to another _may_ be acceptable if you do it only once. From there, it's probably better to use the following: 

```
git checkout gh-pages # checkout gh-pages branch

# add/update 'dist' directory from master branch
git checkout master -- dist  
```

### Updating HTML content

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

### Introducing Git Hooks

Basically, [Git Hooks](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) allow you to automatically run custom scripts at any step in your workflow.
Hooks must be defined in the `.git/hooks/` folder.
Placeholder files are already created, giving a pretty good idea about what's possible or not.  

``` bash
$ ls .git/hooks/
applypatch-msg.sample
commit-msg.sample
post-commit.sample
post-receive.sample
post-update.sample
pre-applypatch.sample
pre-commit.sample
pre-rebase.sample
prepare-commit-msg.sample
update.sample
```
You only need to remove the `.sample` extension to define a hook, then edit the script to create your own awesome automation. 

### Bringing the pieces together

In my case, I created a `post-commit` script. Right after every new commit on the `master` branch, this piece of code runs and does all the crappy work. 

``` bash post-commit
#!/bin/sh
echo "\n| [prettify bookmarklet post-commit hook]"
git checkout gh-pages

# Update bookmarklet script from master branch
git checkout master -- dist lib 

# update index.html & commit changes
grunt replace
git add .
git commit -m "Regenerated index.html from master branch"

git checkout master
echo "| All Done -- Use 'git push --all' instead of 'git push origin master' to push changes"
```

As both `master` and `gh-pages` branches are modified, they both need to be pushed on the remote repository.
I use `git push --all`, which is fine if you don't have any other updated branch. Otherwise, you'll need a specific push for each branch.

## Going further

I'd like to find a way to stop the script if the commit doesn't occur on the `master` branch, but I'm not sure how to do it...

I'll probably also add a `pre-commit` hook to lint/concat/minify the source. 
Grunt.js already simplified this to a one liner, but I often forget to call it before committing changes. 

(Grunt + Git Hooks) appears to be a nice couple with a huge time-saving potential. I'd like to have an opportunity to try it on a larger project and see how it goes.


------------

## References

 - [Easily keep gh-pages in sync with master](http://lea.verou.me/2011/10/easily-keep-gh-pages-in-sync-with-master/) by Lea Verou
 - [Github Pages Workflow](http://oli.jp/2011/github-pages-workflow/) by by Oli Studholme
 - [Git post-commit hook to keep master and gh-pages branch in sync](http://get.inject.io/n/XxsZ6RE7)





