require 'mime/types'

require_relative 'resource'

module Republic

###
# A resource which will be read from a closure.  The resource still needs a filename
class DynamicResource
    include Resource

    ###
    # New resource.
    def initialize(filename, closure)
        @filename = File.basename(filename)
        @closure = closure

        mimeType = MIME::Types.of(@filename).first
        if (mimeType) then
            @mimeType = mimeType.to_s
        else
            @mimeType = "application/octet-stream"
        end
    end

    def name
        @filename
    end

    def mime_type
        @mimeType
    end

    def content
        @closure.call()
    end
end

end
