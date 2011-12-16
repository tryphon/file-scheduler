require 'spec_helper'

describe FileScheduler::AttributesParser do

  it "should be empty without {}" do
    subject.parse("dummy").should be_empty
  end

  it "should be empty when {} is empty" do
    subject.parse("dummy{}").should be_empty
  end

  it "should use {...} at the end of name" do
    subject.parse("dummy{key=value}").should == { :key => "value" }
  end

  it "should use {...} before file extension" do
    subject.parse("dummy{key=value}.wav").should == { :key => "value" }
  end

  it "should not use {...} before a simple dot" do
    subject.parse("dummy{key=value}.otherpart.wav").should be_empty
  end

  it "should support several attributes" do
    subject.parse("dummy{key1=value1,key2=value2}").should == { :key1 => "value1", :key2 => "value2" }
  end

  it "should strip spaces" do
    subject.parse("dummy{ key1 = value1 , key2 = value2 }").should == { :key1 => "value1", :key2 => "value2" }
  end

end
