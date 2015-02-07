module Republic

###
# HTML chapter
class HtmlChapter
    include Chapter

    attr_accessor :text
    attr_accessor :name

    def initialize(&block)
        if (block) then
            yield self
        end
    end

    def to_xhtml
        Nokogiri::HTML(@text).to_xhtml
    end

    def prepare()
        # Search for images in the HTML.
    end

    def resources()
        []
    end
end


end
