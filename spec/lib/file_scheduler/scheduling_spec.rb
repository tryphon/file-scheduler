require 'spec_helper'

describe FileScheduler::Scheduling do

  let(:content) { mock }
  let(:root) { mock :contents => [] }

  subject { FileScheduler::Scheduling.new root, Time.now }

  it "should logged each next content" do
    subject.stub :next_without_log => content
    subject.log.should_receive(:log).with(content)
    subject.next
  end

  describe "schedulable?" do
    
    it "should not accept a content not schedulable_by_time" do
      subject.stub :schedulable_by_repeat? => true
      subject.should_receive(:schedulable_by_time?).with(content).and_return(false)
      subject.schedulable?(content).should be_false
    end

    it "should not accept a content not schedulable_by_repeat" do
      subject.stub :schedulable_by_time? => true
      subject.should_receive(:schedulable_by_repeat?).with(content).and_return(false)
      subject.schedulable?(content).should be_false
    end

    it "should accept a content schedulable by time and repeat" do
      subject.stub :schedulable_by_time? => true
      subject.stub :schedulable_by_repeat? => true
      
      subject.schedulable?(content).should be_true
    end

  end

  describe "schedulable_by_time?" do

    context "when context time_constraints matches time" do
      before(:each) do
        content.stub :time_constraints => mock(:matches? => true)
      end

      it { subject.schedulable_by_time?(content).should be_true }
    end

    context "when content has no time_constraints" do
      before(:each) do
        content.stub :time_constraints => nil
      end

      it { subject.schedulable_by_time?(content).should be_true }
    end

    context "when content time_constraints doesn't match time" do
      before(:each) do
        content.stub :time_constraints => mock(:matches? => false)
      end

      it { subject.schedulable_by_time?(content).should be_false }
    end

  end

  describe "schedulable_by_repeat?" do
    
    context "when content has no repeat_constraints" do

      before(:each) do
        content.stub :repeat_constraints => nil
      end

      it { subject.schedulable_by_repeat?(content).should be_true }
                                                 
    end

    context "when content has never been scheduled" do

      before(:each) do
        content.stub :repeat_constraints => 10
        subject.log.stub :distance => nil
      end

      it { subject.schedulable_by_repeat?(content).should be_true }
                                                 
    end

    context "when content has been scheduled longer than the repeat constraints" do

      before(:each) do
        content.stub :repeat_constraints => 5
        subject.log.stub :distance => 10
      end

      it { subject.schedulable_by_repeat?(content).should be_true }
                                                 
    end

    context "when content has been scheduled less than the repeat constraints" do

      before(:each) do
        content.stub :repeat_constraints => 10
        subject.log.stub :distance => 5
      end

      it { subject.schedulable_by_repeat?(content).should be_false }
                                                 
    end

  end

end
