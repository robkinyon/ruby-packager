# Packager

[![Gem Version](https://img.shields.io/gem/v/packager.svg)](https://rubygems.org/gems/packager-dsl)
[![Gem Downloads](https://img.shields.io/gem/dt/packager.svg)](https://rubygems.org/gems/packager-dsl)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/robkinyon/ruby-packager)

[![Build Status](https://img.shields.io/travis/robkinyon/ruby-packager.svg)](https://travis-ci.org/robkinyon/ruby-packager)
[![Code Climate](https://img.shields.io/codeclimate/github/robkinyon/ruby-packager.svg)](https://codeclimate.com/github/robkinyon/ruby-packager)
[![Code Coverage](https://img.shields.io/codecov/c/github/robkinyon/ruby-packager.svg)](https://codecov.io/github/robkinyon/ruby-packager)
[![Inline docs](http://inch-ci.org/github/robkinyon/ruby-packager.png)](http://inch-ci.org/github/robkinyon/ruby-packager)

## TL;DR

Create the following file:
```ruby
package "foo" do
  version "0.0.1"
  type "deb"
  
  file {
    source "/some/place/in/filesystem"
    dest "/some/place/to/put/it"
  }

  files {
    source "/some/bunch/of/files/*"
    dest "/some/other/place"
  }
end
```

Invoke the associated `packager` script as follows:
```shell
$ packager execute <filename>
```

You now have `foo-0.0.1.x86_64.deb` with several files in it wherever you
invoked `packager`.

## Command-line options

You can pass in the following options to the packager:

### --dryrun

This is a boolean that, if set, will do everything up to, but not including,
invoking fpm.

### `--var pkg_name:foo pkg_version:0.0.1`

This will set helpers that can be used within the DSL. The example will set
the helper `pkg_name` to "foo" and the helper `pkg_version` to "0.0.1".

Due to how Thor works, you must pass multiple variables at the same time. As
shown above, Thor requires keys and values to be joined by a colon (":").

Consider providing helpers for the following:

* Package version
* A root directory (so that your source files can be relative to something)
* Package type (you may want to build a deb vs. an rpm at different times)

## DSL

* package <name>
   * name    String
   * type    String
   * version VersionString
   * file / files
      * source String
      * dest   String
   * requires Array[String]
   * provides Array[String]
