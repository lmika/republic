require 'securerandom'

module Republic

###
# The description of a book.
class Book

    attr_accessor :id
    attr_accessor :title
    attr_accessor :lang
    attr_accessor :creator
    attr_accessor :chapter_entries
    attr_accessor :resources

    def initialize(&block)
        @id = SecureRandom.uuid
        @title = ""
        @lang = "en"
        @creator = ""
        @chapter_entries = []
        @resources = []

        if (block) then
            yield self
        end
    end

    ###
    # Adds a new chapter to the book.
    def << (item)
        case item
            when Chapter
                @chapter_entries << ChapterEntry.new(@chapter_entries.length, item)
            when Resource
                @resources << item
            else
                throw Exception.new("Expected either a Chapter or a Resource")
        end
    end
end

end
