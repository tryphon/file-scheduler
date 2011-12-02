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

end
