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
            book.chapter_entries.each do |entry|
                File.open(File.join(dir, entry.filename), "w") { |f| f.puts entry.chapter.to_xhtml }
            end
        end    
    end
end

end
