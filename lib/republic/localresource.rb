require 'mime/types'

require_relative 'resource'

module Republic

###
# A resource located on the local file system.
class LocalResource
    include Resource

    ###
    # New resource.
    def initialize(filename, archiveName = nil)
        @filename = filename
        @archiveName = ((archiveName.nil?) ? File.basename(filename) : archiveName)

        mimeType = MIME::Types.of(@filename).first
        if (mimeType) then
            @mimeType = mimeType.to_s
        else
            @mimeType = "application/octet-stream"
        end
    end

    def name
        @archiveName
    end

    def mime_type
        @mimeType
    end

    def content
        File.read(@filename)
    end
end

end
