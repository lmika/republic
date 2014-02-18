require 'minitest/autorun'

require 'republic'

class TestResources < Minitest::Test

    TEST_DIR = "/tmp/republictests"

    def setup
        Dir.mkdir(TEST_DIR)
    end

    def teardown
        FileUtils.rm_r(TEST_DIR)       
    end

    def test_local_resources
        file1 = File.dirname(__FILE__) + "/testdata/file.txt"
        file2 = File.dirname(__FILE__) + "/testdata/image.png"

        r1 = Republic::LocalResource.new(file1)
        r2 = Republic::LocalResource.new(file2)

        assert_equal "file.txt", r1.name
        assert_equal "text/plain", r1.mime_type
        assert_equal IO.read(file1), r1.content

        assert_equal "image.png", r2.name
        assert_equal "image/png", r2.mime_type
        assert_equal IO.read(file2), r2.content
    end

    def test_local_resources_with_custom_names
        file1 = File.dirname(__FILE__) + "/testdata/file.txt"
        file2 = File.dirname(__FILE__) + "/testdata/image.png"

        r1 = Republic::LocalResource.new(file1, "somethingElse.txt")
        r2 = Republic::LocalResource.new(file2, "one/with/a/directory.png")

        assert_equal "somethingElse.txt", r1.name
        assert_equal "text/plain", r1.mime_type
        assert_equal IO.read(file1), r1.content

        assert_equal "one/with/a/directory.png", r2.name
        assert_equal "image/png", r2.mime_type
        assert_equal IO.read(file2), r2.content
    end

    def test_saving_resource_in_book
        file1 = File.dirname(__FILE__) + "/testdata/file.txt"
        file2 = File.dirname(__FILE__) + "/testdata/image.png"

        book = Republic::Book.new

        book << Republic::HtmlChapter.new do |c|
            c.name = "Chapter 1"
            c.text = "<p>Just a test.  <img src=\"image.png\"></img></p>"
        end

        book << Republic::LocalResource.new(file1)
        book << Republic::LocalResource.new(file2)

        Republic::Epub.write(book, "/tmp/testepub.epub")
        Republic::DirBinder.write(book, TEST_DIR + "/book")

        assert File.file?(TEST_DIR + "/book/file.txt")
        assert File.file?(TEST_DIR + "/book/image.png")
        assert_equal IO.read(file1), IO.read(TEST_DIR + "/book/file.txt")
        assert_equal IO.read(file2), IO.read(TEST_DIR + "/book/image.png")
    end

    def test_saving_resource_in_book
        file1 = File.dirname(__FILE__) + "/testdata/file.txt"
        file2 = File.dirname(__FILE__) + "/testdata/image.png"

        book = Republic::Book.new

        book << Republic::HtmlChapter.new do |c|
            c.name = "Chapter 1"
            c.text = "<p>Just a test.  <img src=\"image.png\"></img></p>"
        end

        book << Republic::LocalResource.new(file1, "custom.txt")
        book << Republic::LocalResource.new(file2, "subdir/image.png")

        Republic::Epub.write(book, "/tmp/testepub.epub")
        Republic::DirBinder.write(book, TEST_DIR + "/book")

        assert File.file?(TEST_DIR + "/book/custom.txt")
        assert File.file?(TEST_DIR + "/book/subdir/image.png")
        assert_equal IO.read(file1), IO.read(TEST_DIR + "/book/custom.txt")
        assert_equal IO.read(file2), IO.read(TEST_DIR + "/book/subdir/image.png")
    end
end
