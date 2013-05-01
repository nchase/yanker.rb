require 'debugger'
require 'resource'

describe FileUploader::Resource do
  FILENAME = "c43a8cbe52fecbe6fa25f0b85abb44f6_o.jpg"
  PARAM = "?#{Time.now.to_i}&whyisthisurlsoLong=true&thisistotallyaRealURI.bleh"

  before(:each) do
    resource_file = File.open(File.expand_path("../../test/fixtures/#{FILENAME}", __FILE__))
    resource_url = "http://content.internetvideoarchive.com/content/photos/6894/28955235_.jpg"

    @resource_file = FileUploader::Resource.create(resource_file)
    @resource_url = FileUploader::Resource.create(resource_url)
    @resources = [@resource_file, @resource_url]
  end

  after(:each) do
    @resources.each { |resource| resource.destroy }
  end

  it "knows its extension" do
    @resources.each { |resource|
      expect(resource.extension).to eq('jpg')
    }
  end

  it "even knows its extension when URL has fairly-funky params" do
    @resources.each { |resource|
      expect(paramify(resource.extension).split("?").first.match(/(\?|\.|&)/)).to be_nil
    }
  end

  it "knows its mimetype" do
    @resources.each { |resource|
      expect(resource.mime_type(paramify(resource.uri))).to eq("image/jpeg")
    }
  end

  it "has a reasonable basename, no matter where it's from" do
    @resources.each { |resource|
      expect(resource.basename).to be_a_kind_of(String)
    }
  end

  it "generates a local tempfile, no matter where it's from" do
    @resources.each { |resource|
      expect(File.exist?(resource.basename)).to be_true
    }
  end

  it "mock-sends to the datastore" do
    stub_const("S3_KEY", "your_key")
    stub_const("S3_SECRET", "your_secret")
    stub_const("S3_BUCKET", "your_bucketname")

    class S3Object < AWS::S3::S3Object
      set_current_bucket_to S3_BUCKET
    end

    @resources.each { |resource|
      resource.stub(:send).and_return(true)
      resource.send(S3_KEY, S3_SECRET, S3_BUCKET)

      S3Object.stub(:exists?).and_return(true)

      expect(S3Object.exists?(resource.basename)).to be_true
    }
  end

  def paramify(string)
    string + PARAM
  end
end
