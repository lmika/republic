module Repub

###
# An instance of a chapter in a book.  This contains information for the book binding.
class ChapterEntry

    attr_accessor :chapter
    attr_reader :id
    attr_reader :filename
    attr_reader :media_type
    attr_reader :toc_entry

    def initialize(index, chapter)
        @chapter = chapter

        @id = "c#{index}"
        @filename = "c#{index}.xhtml"
        @media_type = "application/xhtml+xml"
        @toc_entry = chapter.name
    end
end

end
