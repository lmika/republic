module Republic

###
# Chapter mixin.
module Chapter

    ###
    # Returns the chapter name.  If not nil, the title will appear in the TOC.
    def name()
        nil
    end

    ###
    # Returns the content of the chapter, as XHTML.
    def to_xhtml()
        nil
    end

    # TODO: Resources (like images, etc)
end

end
