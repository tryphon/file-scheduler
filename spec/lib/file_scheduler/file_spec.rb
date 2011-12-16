require 'spec_helper'

describe FileScheduler::File do

  subject { file "dummy" }

  def file(file, parent = nil)
    FileScheduler::File.new file, parent
  end

  describe "#name" do
    
    it "should use path basename" do
      file("/path/to/basename").name.should == "basename"
    end

  end

  describe "#local_time_constraints" do
    
    it "should parse the time specifications in the name" do
      file("/path/to/12h30m-dummy",mock).local_time_constraints.should == FileScheduler::TimeMark.new(:hour => 12, :minute => 30)
    end

    it "should be nil when parent isn't defined (root directory)" do
      file("/path/to/12h30m-dummy").local_time_constraints.should be_nil
    end

  end

  describe "#time_constraints" do

    it "should concat with parent constraints" do
      parent = mock(:time_constraints => FileScheduler::TimeMark.new(:week_day => 1))
      file("/path/1w/12h30m-dummy", parent).time_constraints.should == FileScheduler::TimeChain.new(parent.time_constraints, FileScheduler::TimeMark.new(:hour => 12, :minute => 30))
    end

  end

  describe "file_system_children" do
    
    it "should return pathnames of files and directories present under file" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "file"
        directory = base.mkpath "directory"

        file(base).file_system_children.should include(file, directory)
      end
    end

  end

  describe "children" do
    
    it "should return children created from files and directories present under path" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "file"
        directory = base.mkpath "directory"

        parent = file(base)
        parent.children.should include(file(file, parent))
        parent.children.should include(file(directory, parent))
      end
    end

    it "should ignore files prefixed with underscore" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "_ignored_file"
        directory = base.mkpath "_ignored_directory"
        
        file(base).children.should be_empty
      end
    end

  end

  describe "local_attributes" do
    
    it "should use attributes found in name" do
      file("dummy{key=value}.wav").local_attributes.should == { :key => "value" }
    end

  end

  describe "#attributes" do

    it "should merge parent attributes with local attributes" do
      parent = mock(:attributes => {:key1 => "parent_value1", :key2 => "value2"})
      file("dummy{key1=value1}.wav",parent).attributes.should == { :key1 => "value1", :key2 => "value2" }
    end
    
  end

  require File.expand_path("../content_shared_examples", __FILE__)

  it_behaves_like "a content"

end
