require 'fileutils'

require_relative 'binder.rb'

module Republic

###
# Writes the content of the book to a directory.  Used for testing purposes.
class DirBinder
    class << self
        def write(book, outfile)
            Dir.mkdir(outfile)
            write_to_dir(book, outfile)
        end

        private

        def write_to_dir(book, dir)
            # Write the chapters
            book.chapter_entries.each do |entry|
                File.open(File.join(dir, entry.filename), "w") { |f| f.puts entry.chapter.to_xhtml }
            end

            # Write the resources
            book.resources.each do |resource|
                fullname = File.join(dir, resource.name)

                FileUtils.mkdir_p(File.dirname(fullname))
                File.open(fullname, "w") { |f| f.print resource.content }
            end
        end    
    end
end

end
