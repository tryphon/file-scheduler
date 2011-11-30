require 'spec_helper'

describe FileScheduler::TimeInterval do

  let(:time) { Time.now }

  def mark(attributes = {})
    FileScheduler::TimeMark.new attributes
  end
  
  def interval(from, to)
    from = mark(from) if Hash === from
    to = mark(to) if Hash === to

    FileScheduler::TimeInterval.new from, to
  end

  describe "#includes?" do

    it "should include a Time when all defined ranges are verified" do
      interval(mark((time - 60).attributes), mark((time + 60).attributes)).should include(time)
    end

    it "should include 13h55 in 12h30m-15h45m" do
      interval({:hour => 12, :minute => 30}, {:hour => 15, :minute => 45}).should include(Time.parse("13:55"))
    end

    it "should include 00h15 in 22h30-06h45" do
      interval({:hour => 22, :minute => 30}, {:hour => 06, :minute => 45}).should include(Time.parse("00:15"))
    end

    it "should not include 00h15 in 22h30-2009Y06h45" do
      interval({:hour => 22, :minute => 30}, {:year => 2009, :hour => 06, :minute => 45}).should_not include(Time.parse("00:15"))
    end
    
  end

  describe "#common_attributes" do
    
    it "should return attributes present in from and to" do
      interval({:hour => 12, :minute => 30},{:hour => 14, :second => 30}).common_attributes.should == [:hour]
    end

  end

  describe "#reversed_attributes" do

    it "should return attributes with reversed values" do
      interval({:hour => 22, :minute => 0},{:hour => 06, :minute => 30}).reversed_attributes.should == [:hour]
    end

  end

end
