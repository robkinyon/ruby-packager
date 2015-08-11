# Packager

[![Gem Version](https://img.shields.io/gem/v/packager.svg)](https://rubygems.org/gems/packager)
[![Gem Downloads](https://img.shields.io/gem/dt/packager.svg)](https://rubygems.org/gems/packager)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/robkinyon/ruby-packager)

[![Build Status](https://img.shields.io/travis/robkinyon/ruby-packager.svg)](https://travis-ci.org/robkinyon/ruby-packager)
[![Code Climate](https://img.shields.io/codeclimate/github/robkinyon/ruby-packager.svg)](https://codeclimate.com/github/robkinyon/ruby-packager)
[![Code Coverage](https://img.shields.io/codecov/c/github/robkinyon/ruby-packager.svg)](https://codecov.io/github/robkinyon/ruby-packager)
[![Inline docs](http://inch-ci.org/github/robkinyon/ruby-packager.png)](http://inch-ci.org/github/robkinyon/ruby-packager)

## TL;DR

Create the following file:
```ruby
package {
  name "foo"
  version "0.0.1"
  
  file {
    source "/some/place/in/filesystem"
    dest "/some/place/to/put/it"
  }

  files {
    source "/some/bunch/of/files/*"
    dest "/some/other/place"
  }
}
```

Invoke the associated `packager` script as follows:
```shell
$ packager --output deb <filename>
```

You now have `foo-0.0.1.x86_64.deb` with several files in it wherever you
invoked `packager`.

## Methods

* package
   * name    String
   * version VersionString
   * file / files
      * source String
      * dest   String
