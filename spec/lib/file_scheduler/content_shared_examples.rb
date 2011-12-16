shared_examples "a content" do

  describe "#repeat_constraints" do
    
    it "should return the number defined by 'repeat' attribute" do
      subject.stub :attributes => { :repeat => "5" }
      subject.repeat_constraints.should == 5
    end

  end

end
