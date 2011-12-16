require 'spec_helper'

describe FileScheduler::Log do
  
  let(:content) { mock }

  def another_content
    mock
  end

  describe "#distance" do
    
    it "should be nil when content is unknown" do
      subject.distance(mock).should be_nil
    end

    it "should be zero when content has been logged just before" do
      subject.log(content)
      subject.distance(content).should be_zero
    end

    it "should be increase each time another content is logged" do
      subject.log(content)
      5.times { subject.log another_content }
      subject.distance(content).should == 5
    end
    
  end

  describe "#log" do
    
    it "should returh the logged content" do
      subject.log(content).should == content
    end

  end

  describe "#max_size" do
    
    it "should limit the number of reminded contents" do
      subject.max_size = 10
      subject.log(content)
      10.times { subject.log another_content }
      subject.distance(content).should be_nil
    end

  end
  

end
