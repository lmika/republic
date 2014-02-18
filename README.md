Republic - A Ruby Epub builder
===========================

A small library used to build EPub files in Ruby.

Building
--------

The Gem has not yet been published, so to use it, check out the code and then build the gem manually:

    $ gem build republic.gemspec
    $ gem install ./republic-0.0.1.gem

The gem will be published soon.

Example
-------

```ruby
#!/usr/bin/env ruby

require 'republic'

book = Republic::Book.new do |b|
    b.title = "Hello World - the novel"
    b.creator = "you"

    b << Republic::HtmlChapter.new do |c|
        c.name = "Hello"
        c.text = "<html><body><p>Your prose here.</p></body></html>"
    end
end

Republic::Epub.write(book, "out.epub")
```
