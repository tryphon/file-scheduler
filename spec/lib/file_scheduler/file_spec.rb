require 'spec_helper'

describe FileScheduler::File do

  describe "#name" do
    
    it "should use path basename" do
      FileScheduler::File.new("/path/to/basename").name.should == "basename"
    end

  end

  describe "#local_time_constraints" do
    
    it "should parse the time specifications in the name" do
      FileScheduler::File.new("/path/to/12h30m-dummy").local_time_constraints.should == FileScheduler::TimeMark.new(:hour => 12, :minute => 30)
    end

  end

  describe "#time_constraints" do

    it "should concat with parent constraints" do
      parent = mock(:time_constraints => FileScheduler::TimeMark.new(:week_day => 1))
      FileScheduler::File.new("/path/1w/12h30m-dummy", parent).time_constraints.should == FileScheduler::TimeChain.new(parent.time_constraints, FileScheduler::TimeMark.new(:hour => 12, :minute => 30))
    end

  end

  describe "file_system_children" do
    
    it "should return pathnames of files and directories present under file" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "file"
        directory = base.mkpath "directory"

        FileScheduler::File.new(base).file_system_children.should include(file, directory)
      end
    end

  end

  describe "children" do
    
    it "should return children created from files and directories present under path" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "file"
        directory = base.mkpath "directory"

        parent = FileScheduler::File.new(base)
        parent.children.should include(FileScheduler::File.new(file, parent))
        parent.children.should include(FileScheduler::File.new(directory, parent))
      end
    end

    it "should ignore files prefixed with underscore" do
      Dir.mktmpdir do |base|
        base = Pathname.new(base)

        file = base.touch "_ignored_file"
        directory = base.mkpath "_ignored_directory"
        
        FileScheduler::File.new(base).children.should be_empty
      end
    end

  end

end
