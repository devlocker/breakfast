---
layout: default
---

# Migrating from Asset Pipeline

Moving your existing Rails 5 application to Breakfast is relatively straight
forward. Breaking it down step by step:

## Install Breakfast
Following the steps in Getting Started Guide - add `breakfast` to your `Gemfile` and run the generator 


~~~ruby
# In Gemfile
gem "breakfast"

# Terminal
$ bundle install
$ rails generate breakfast:install
~~~

## Move images over

Easiest step. Move the contents of `app/assets/images` to `app/frontend/images`. `image_tag`s will still work the same as before.

## Move CSS over

Copy the contents of `app/assets/stylsheets` to `app/frontend/css`.

`application.css` that comes with the asset pipeline allows for magic `require`
comments. These will no longer be supported. 
