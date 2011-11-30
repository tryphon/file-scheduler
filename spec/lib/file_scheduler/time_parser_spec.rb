require 'spec_helper'

describe FileScheduler::TimeParser do

  describe "#parse" do

    it "should return nil for dummy" do
      subject.parse("dummy").should be_nil
    end
    
    it "should parse 12h30m-dummy" do
      subject.parse("12h30m-dummy").should == FileScheduler::TimeMark.new(:hour => 12, :minute => 30)
    end

    it "should parse 1w12h30m-dummy" do
      subject.parse("1w12h30m-dummy").should == FileScheduler::TimeMark.new(:week_day => 1, :hour => 12, :minute => 30)
    end

    it "should parse 2011y11M24d12h30m-dummy" do
      subject.parse("1w12h30m-dummy").should == FileScheduler::TimeMark.new(:week_day => 1, :hour => 12, :minute => 30)
    end

    it "should parse 12h30m-15h45m-dummy" do
      subject.parse("12h30m-15h45m-dummy").should == FileScheduler::TimeInterval.new(FileScheduler::TimeMark.new(:hour => 12, :minute => 30), FileScheduler::TimeMark.new(:hour => 15, :minute => 45))
    end

  end

end
