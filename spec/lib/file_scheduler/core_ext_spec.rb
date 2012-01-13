require 'spec_helper'

describe Array do

  subject { [1,2,3] }

  it "should use a random index" do
    subject.should_receive(:rand).with(subject.size).and_return(1)
    subject.sample
  end

  it "should return the item at random index" do
    subject.stub :rand => 1
    subject.sample.should == subject[1]
  end

end
