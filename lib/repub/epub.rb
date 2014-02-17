require 'nokogiri'
require 'zip/zip'

require_relative 'binder.rb'

module Repub

###
# A binder which converts the book into an .epub
class Epub
    include Binder

    def initialize()
    end

    def write(book, outfile)
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

                        # TODO: Resources
                    end
                }
                x.spine("toc" => "toc") {
                    book.chapter_entries.each do |entry|
                        if (entry.toc_entry) then
                            x.itemref("idref" => entry.id)
                        end
                    end
                }
            }
        end.to_xml
    end

    ###
    # Generates the NCX file
    def gen_ncx(book)
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
                    book.chapter_entries.each do |entry|
                        if (entry.toc_entry) then
                            x.navPoint("class" => "chapter", "id" => "navPoint-#{order.to_s}", "playOrder" => order.to_s) {
                                x.navLabel { x.text_ { x.text entry.toc_entry } }
                                x.content("src" => entry.filename)
                            }
                            order = order + 1
                        end
                    end
                }
            }
        end.to_xml
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
        Zip::ZipOutputStream::open(outfile) do |zip|
            # MimeType
            zip.put_next_entry("mimetype", nil, nil, Zip::ZipEntry::STORED, Zlib::NO_COMPRESSION)
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

                # TODO: Resources
            end
        end
    end
end

end
