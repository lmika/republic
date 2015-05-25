Gem::Specification.new do |s|
    s.name          = 'republic'
    s.version       = '0.0.1'
    s.date          = '2014-02-18'
    s.summary       = 'Republic'
    s.description   = 'A Ruby EPub builder'
    s.authors       = ['Leon Mika']
    s.email         = 'lmika314@gmail.com'
    s.license       = 'MIT'

    s.files         = [
        "lib/republic.rb",
        "lib/republic/binder.rb",
        "lib/republic/book.rb",
        "lib/republic/chapterentry.rb",
        "lib/republic/chapter.rb",
        "lib/republic/resource.rb",
        "lib/republic/localresource.rb",
        "lib/republic/dynamicresource.rb",
        "lib/republic/epub.rb",
        "lib/republic/dirbinder.rb",
        "lib/republic/htmlchapter.rb"
    ]

    s.add_runtime_dependency 'rubyzip', '~> 1.1'
    s.add_runtime_dependency 'nokogiri', '~> 1.5'
    s.add_runtime_dependency 'mime-types', '~> 2.5'
end
