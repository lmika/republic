require 'nokogiri'
require 'zip'

require_relative 'binder.rb'

module Republic

###
# A binder which converts the book into an .epub
class Epub 
    class << self
        def initialize()
        end

        def write(book, outfile)
            book.prepare
            build_epub(book, outfile)
        end

        private

        ###
        # Generates the OPF file.
        def gen_opf(book)
            Nokogiri::XML::Builder.new do |x|
                x.package("version" => "2.0", "xmlns" => "http://www.idpf.org/2007/opf", "unique-identifier" => "BookId") {
                    x.metadata("xmlns:dc" => "http://purl.org/dc/elements/1.1/") {
                        x['dc'].title book.title
                        x['dc'].language book.lang
                        x['dc'].identifier("id" => "BookId") { x.text book.id }
                        x['dc'].creator book.creator
                        x.meta("name" => "cover", "content" => "cover")
                    }
                    x.manifest {
                        x.item("id" => "toc", "href" => "toc.ncx", "media-type" => "application/x-dtbncx+xml")
                        book.chapter_entries.each do |entry|
                            x.item("id" => entry.id, "href" => entry.filename, "media-type" => entry.media_type)
                        end
                        book.resources.each_index do |resource_index|
                            resource = book.resources[resource_index]
                            x.item("id" => "r#{resource_index}", "href" => resource.name, "media-type" => resource.mime_type)
                        end
                    }
                    x.spine("toc" => "toc") {
                        book.chapter_entries.each do |entry|
                            x.itemref("idref" => entry.id)
                        end
                    }
                }
            end.to_xml
        end

        ###
        # Generates the NCX file
        def gen_ncx(book)
            chapterAndEntries = line_up_entries_behind_chapters(book.chapter_entries)
            Nokogiri::XML::Builder.new do |x|
                x.ncx("version" => "2005-1", "xml:lang" => book.lang, "xmlns" => "http://www.daisy.org/z3986/2005/ncx/") {
                    x.head {
                        x.meta("name" => "dtb:uid", "content" => book.id)
                        x.meta("name" => "dtb:depth", "content" => "1")
                        x.meta("name" => "dtb:totalPageCount", "content" => "0")
                        x.meta("name" => "dtb:maxPageCount", "content" => "0")
                    }
                    x.docTitle { x.text_ { x.text book.title } }
                    x.docAuthor { x.text_ { x.text book.creator } }
                    x.navMap {
                        order = 1

                        # There must be one navPoint per entry in the ToC.  It will appear even
                        # when no navLabel is set.
                        # Chapters with a false toc_entry should be added to the last navPoint for an entry
                        # with a true toc_entry
                        #
                        chapterAndEntries.each do |chapter|
                            x.navPoint("class" => "chapter", "id" => "navPoint-#{order.to_s}", "playOrder" => order.to_s) {
                                firstEntry = chapter.first
                                x.navLabel { x.text_ { x.text firstEntry.toc_entry } }

                                chapter.each do |entry|
                                    x.content("src" => entry.filename)
                                end
                            }
                            order = order + 1
                        end
                    }
                }
            end.to_xml
        end

        ###
        # Line up all entries with a false toc_entry "behind" (i.e. after) entries
        # with a true toc_entry.  Returns an array of arrays with the first array
        # either being the first entry or an entry with a toc
        def line_up_entries_behind_chapters(entries)
            arrays = []
            lastArray = nil

            entries.each do |entry|
                if (lastArray == nil) or (entry.toc_entry) then
                    lastArray = [entry]
                    arrays << lastArray
                else
                    lastArray << entry
                end
            end

            arrays
        end

        ###
        # Generate the OCF file
        def gen_ocf(book)
            Nokogiri::XML::Builder.new do |x|
                x.container("version" => "1.0", "xmlns" => "urn:oasis:names:tc:opendocument:xmlns:container") {
                    x.rootfiles {
                        x.rootfile("full-path" => "OPS/book.opf", "media-type" => "application/oebps-package+xml")
                    }
                }
            end.to_xml
        end

        ###
        # Creates the .epub file for a particular book.
        def build_epub(book, outfile)
            Zip::OutputStream::open(outfile) do |zip|
                # MimeType
                zip.put_next_entry("mimetype", nil, nil, Zip::Entry::STORED, Zlib::NO_COMPRESSION)
                zip.write "application/epub+zip"

                # Container
                zip.put_next_entry("META-INF/container.xml")
                zip.write(gen_ocf(book))

                # Book OPF file
                zip.put_next_entry("OPS/book.opf")
                zip.write(gen_opf(book))

                # TOC Ncx File
                zip.put_next_entry("OPS/toc.ncx")
                zip.write(gen_ncx(book))

                # The contents
                book.chapter_entries.each do |entry|
                    zip.put_next_entry("OPS/" + entry.filename)
                    zip.write(entry.chapter.to_xhtml)
                end
                book.resources.each do |resource|
                    zip.put_next_entry("OPS/" + resource.name)
                    zip.write(resource.content)
                end
            end
        end
    end
end

end
