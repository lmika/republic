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

    def initialize(&block)
        @id = SecureRandom.uuid
        @title = ""
        @lang = "en"
        @creator = ""
        @chapter_entries = []

        if (block) then
            yield self
        end
    end

    ###
    # Adds a new chapter to the book.
    def << (chapter)
        @chapter_entries << ChapterEntry.new(@chapter_entries .length, chapter)
    end
end

end
