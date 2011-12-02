require 'spec_helper'

describe FileScheduler::Playlist do

  def url(definition)
    FileScheduler::URL.new definition
  end

  describe "contents" do
    
    it "should return contents described by URLs" do
      FileScheduler::Playlist.new(:content => "dummy").contents.should include(url("dummy"))
    end

  end

end
