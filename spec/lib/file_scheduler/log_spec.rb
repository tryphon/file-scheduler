require 'spec_helper'

require 'tempfile'

describe FileScheduler::Log do
  
  let(:content) { mock }

  def another_content
    mock
  end

  describe "#distance" do
    
    it "should be nil when content is unknown" do
      subject.distance(mock).should be_nil
    end

    it "should be zero when content has been logged just before" do
      subject.log(content)
      subject.distance(content).should be_zero
    end

    it "should be increase each time another content is logged" do
      subject.log(content)
      5.times { subject.log another_content }
      subject.distance(content).should == 5
    end
    
  end

  describe "#log" do
    
    it "should returh the logged content" do
      subject.log(content).should == content
    end

  end

  describe "#max_size" do
    
    it "should limit the number of reminded contents" do
      subject.max_size = 10
      subject.log(content)
      10.times { subject.log another_content }
      subject.distance(content).should be_nil
    end

  end

  describe "#load" do

    let(:contents) { %w{a b c} }
    let(:marshalled_contents) { Marshal.dump contents }
    
    it "should use a marshalled data as contents" do
      subject.load marshalled_contents
      subject.to_a.should == contents
    end

    it "should load a given filename" do
      Tempfile.open("loadspec") do |f|
        f.write marshalled_contents
        f.flush

        subject.load f.path
      end

      subject.to_a.should == contents
    end

    it "should left empty if the given file doesn't exist" do
      subject.load "/path/to/dummy/file"
      subject.should be_empty
    end

  end

  describe "#dump" do
    
    let(:contents) { %w{a b c} }
    let(:marshalled_contents) { Marshal.dump contents }

    it "should return marshalled contents" do
      contents.reverse.each { |c| subject.log c }
      subject.dump.should == marshalled_contents
    end

  end

  describe "#save" do
    
    it "should write in given file the dumped log" do
      Tempfile.open("save_spec") do |f|
        subject.save(f.path)
        FileScheduler::Log.new.load(f.path).should == subject
      end
    end

  end
  

end
