module Repub

###
# HTML chapter
class HtmlChapter
    include Chapter

    attr_accessor :text
    attr_accessor :name

    def to_xhtml
        Nokogiri::HTML(@text).to_xhtml
    end
end


end
