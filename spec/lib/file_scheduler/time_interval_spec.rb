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

    it "should include 13h55 in 12h30m-15h45m" do
      interval({:hour => 12, :minute => 30}, {:hour => 15, :minute => 45}).should include(Time.parse("13:55"))
    end

    it "should include 00h15 in 22h30-06h45" do
      interval({:hour => 22, :minute => 30}, {:hour => 06, :minute => 45}).should include(Time.parse("00:15"))
    end

    it "should include 23h45 in 22h30-06h45" do
      interval({:hour => 22, :minute => 30}, {:hour => 06, :minute => 45}).should include(Time.parse("23:45"))
    end

    it "should not include 00h15 in 22h30-2009Y06h45" do
      interval({:hour => 22, :minute => 30}, {:year => 2009, :hour => 06, :minute => 45}).should_not include(Time.parse("00:15"))
    end
    
  end

end
