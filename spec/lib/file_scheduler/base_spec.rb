require 'spec_helper'

describe FileScheduler::Base do

  before(:each) do
    subject.root = mock(:contents => mock)
  end

  let(:content) { mock }

  describe "#contents" do

    it "should return root contents" do
      subject.contents.should == subject.root.contents
    end
    
  end

  describe "scheduling" do

    let(:time) { Time.now }
    
    it "should return a Scheduling with specified time" do
      subject.scheduling(time).time.should == time
    end

    it "should return a Scheduling with the same root" do
      subject.scheduling.root.should == subject.root
    end

    it "should return a Scheduling with the same log" do
      subject.scheduling.log.should == subject.log
    end

  end

  describe "next" do

    let(:next_content) { content }
    
    before(:each) do
      subject.stub :scheduling => mock(:next => content)
    end
    
    it "should return the next content choosed by scheduling" do
      subject.next.should == next_content
    end

    it "should invoke after_next with selected content" do
      subject.should_receive(:after_next).with(next_content)
      subject.next
    end

  end

  describe "forced_next" do

    let(:forced_content) { content }
    
    before(:each) do
      subject.stub :scheduling => mock(:forced_next => content)
    end
    
    it "should return the forced content choosed by scheduling" do
      subject.forced_next.should == forced_content
    end

    it "should invoke after_next with selected content" do
      subject.should_receive(:after_next).with(forced_content)
      subject.forced_next
    end

  end

end
