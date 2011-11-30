require 'spec_helper'

describe FileScheduler::TimeMark do

  let(:time) { Time.now }

  def mark(attributes = {})
    attributes = attributes.attributes if attributes.respond_to?(:attributes)
    FileScheduler::TimeMark.new attributes
  end

  describe "#matches?" do

    RSpec::Matchers.define :match do |time|
      match do |mark|
        mark.matches? time
      end
    end

    it "should match a Time when all defined attributes are equal" do
      mark(time).should match(time)
    end

    it "should not match a Time when an attribute is diffirent" do
      mark(time.attributes.merge(:month => time.month + 1)).should_not match(time)
    end

    it "should match week day" do
      mark(time.attributes(:week_day)).should match(time)
    end

  end

  describe "#compare_to" do

    it "should be smaller when all attributes are equal or smaller" do
      mark(time).should < time + 60
    end

    it "should be equal when all attributes are equal" do
      mark(time).should == time
    end

    it "should be higher when all attributes are equal or higher" do
      mark(time).should > time - 60
    end

    it "should reverse value comparaison for specified reversed attributes" do
      mark(:hour => (time.hour - 1)).compare_to(time, [:hour]).should > 0
    end

  end
  

end
