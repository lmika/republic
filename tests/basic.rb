require 'fileutils'
require 'minitest/autorun'

require 'republic'

class TestBasic < Minitest::Test

    TEST_DIR = "/tmp/republictests"

    def setup
        Dir.mkdir(TEST_DIR)
    end

    def teardown
        FileUtils.rm_r(TEST_DIR)       
    end

    ###
    # Test the creation of a single book.
    def test_simple
        book = Republic::Book.new do |b|
            b.title = "Test book"
            b.creator = "Test book"

            b << Republic::HtmlChapter.new do |c|
                c.name = "Hello"
                c.text = "<html><body><p>Your prose here.</p></body></html>"
            end
        end
        Republic::DirBinder.write(book, TEST_DIR + "/book1")

        assert File.file?(TEST_DIR + "/book1/chap0000.xhtml"), "First chapter present"
    end
end
