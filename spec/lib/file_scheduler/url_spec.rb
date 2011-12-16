require 'spec_helper'

describe FileScheduler::URL do

  def url(definition)
    FileScheduler::URL.new definition
  end

  describe "#time_constraints" do

    it "should parse 12h30m-dummy" do
      url("12h30m-dummy").time_constraints.should == FileScheduler::TimeMark.new(:hour => 12, :minute => 30)
    end

    it "should parse 1w/12h30m-dummy" do
      url("1w/12h30m-dummy").time_constraints.should == FileScheduler::TimeChain.new(FileScheduler::TimeMark.new(:week_day => 1), FileScheduler::TimeMark.new(:hour => 12, :minute => 30))
    end

  end

  describe "#attributes" do

    it "should merge the parts attributes" do
      url("parent{key1=parent_value,key2=value2}/dummy{key1=value1}.wav").attributes.should == { :key1 => "value1", :key2 => "value2" }
    end
    
  end

  require File.expand_path("../content_shared_examples", __FILE__)

  it_behaves_like "a content"

end
