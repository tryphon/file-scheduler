require 'spec_helper'

require 'time'

class TestDir < Pathname

  def self.open
    Dir.mktmpdir do |directory|
      yield TestDir.new(directory)
    end
  end

  def file(name)
    (self + name).tap do |file|
      file.dirname.mkpath
      FileUtils.touch file
    end
  end

  def scheduler
    @scheduler ||= FileScheduler::Base.new self
  end

  def next(time = nil)
    time = time ? Time::parse(time) : Time.now
    next_content = scheduler.next(time)
    next_content.to_s.gsub("#{self}/", "") if next_content
  end

end

class TestPlaylist

  attr_reader :definition

  def initialize
    @definition = ""
  end

  def url(definition)
    @definition << "#{definition}\n"
  end

  def scheduler
    @scheduler ||= FileScheduler::Base.new :playlist => definition
  end

  def next(time)
    scheduler.next(Time::parse(time)).to_s.gsub("#{self}/", "")
  end

end

describe FileScheduler do

  def at(time)
    Time::parse time
  end

  it "should support time intervals in files" do
    TestDir.open do |directory|
      directory.file "13h-15h-test.wav"
      directory.file "15h-17h-test.wav"

      directory.next("13:30").should == "13h-15h-test.wav"
      directory.next("16:00").should == "15h-17h-test.wav"
    end
  end

  it "should support time intervals in directories" do
    TestDir.open do |directory|
      directory.file "13h-15h/test1.wav"
      directory.file "15h-17h/test2.wav"

      directory.next("13:30").should == "13h-15h/test1.wav"
      directory.next("16:00").should == "15h-17h/test2.wav"
    end
  end

  it "should support fixed time" do
    TestDir.open do |directory|
      directory.file "test.wav"
      directory.file "T13h-test.wav"

      directory.next("13:00").should == "T13h-test.wav"
    end
  end

  it "should support repeat constraint" do
    TestDir.open do |directory|
      directory.file "test{repeat=+5}.wav"

      directory.next.should == "test{repeat=+5}.wav"
      directory.next.should be_nil
    end
  end

  context "with playlist" do
    it "should support time intervals in files" do
      TestPlaylist.new.tap do |playlist|
        playlist.url "13h-15h-test.wav"
        playlist.url "15h-17h-test.wav"

        playlist.next("16:00").should == "15h-17h-test.wav"
      end
    end
  end

end
