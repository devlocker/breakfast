---
layout: default
---

# Setting up CI
Potentially, in order to get CI to run properly you will need to manually ran
the Brunch build command. This requires having Node + NPM installed and updated
on your CI machine.

## Examples

### CircleCI
Update your `circle.yml` file to look like this:

~~~yml
machine:
  environment:
    RAILS_ENV: test
  node:
    version: 6.1.0
  ruby:
    version: 2.3.1

dependencies:
  post:
    - npm install
    - ./node_modules/brunch/bin/brunch build
~~~

### Travis CI

Travis is a bit more work. Before running your tests you will need a newer
version of Node. The snippet below installs
[nvm](https://github.com/creationix/nvm) and uses it to install Node.

~~~yml
sudo: false
language: ruby
rvm:
  - 2.3.1
before_install:
  - gem install bundler -v 1.12.5
  - rm -rf ~/.nvm && git clone https://github.com/creationix/nvm.git ~/.nvm && (cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`) && source ~/.nvm/nvm.sh && nvm install $TRAVIS_NODE_VERSION
  - npm install
  - ./node_modules/brunch/bin/brunch build

env:
  - TRAVIS_NODE_VERSION="6.1"
~~~
