require 'securerandom'

module Repub

###
# The description of a book.
class Book

    attr_accessor :id
    attr_accessor :title
    attr_accessor :lang
    attr_accessor :creator
    attr_accessor :chapter_entries

    def initialize()
        @id = SecureRandom.uuid
        @title = ""
        @lang = "en"
        @creator = ""
        @chapter_entries = []
    end

    ###
    # Adds a new chapter to the book.
    def << (chapter)
        @chapter_entries << ChapterEntry.new(@chapter_entries .length, chapter)
    end
end

end
