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

    ###
    # Test the creation of a single book with a few chapters.
    def test_more_chapters
        Republic::DirBinder.write(Republic::Book.new { |b|
            b << Republic::HtmlChapter.new { |c| 
                c.text = "<p>This is chapter 1</p>"
            }
            b << Republic::HtmlChapter.new { |c| 
                c.text = "<p>This is chapter 2</p>"
            }
            b << Republic::HtmlChapter.new { |c| 
                c.text = "<p>This is chapter 3</p>"
            }
        }, TEST_DIR + "/book2")

        assert File.file?(TEST_DIR + "/book2/chap0000.xhtml"), "First chapter present"
        assert File.file?(TEST_DIR + "/book2/chap0001.xhtml"), "Second chapter present"
        assert File.file?(TEST_DIR + "/book2/chap0002.xhtml"), "Third chapter present"

        assert_match /.*This is chapter 1.*/, IO.read(TEST_DIR + "/book2/chap0000.xhtml")
        assert_match /.*This is chapter 2.*/, IO.read(TEST_DIR + "/book2/chap0001.xhtml")
        assert_match /.*This is chapter 3.*/, IO.read(TEST_DIR + "/book2/chap0002.xhtml")
    end
end
