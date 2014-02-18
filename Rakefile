task :default => [:test, :gem]

task :gem do
    system "gem build republic.gemspec"
end

# Run unit tests
task :test do
    ruby "-I" + File.dirname(__FILE__) + "/lib", "tests/basic.rb"
    ruby "-I" + File.dirname(__FILE__) + "/lib", "tests/resources.rb"
end

