require 'open-uri'

module FileScheduler
  class Playlist

    attr_accessor :url, :content

    def initialize(attributes = {})
      if String === attributes 
        attributes = 
          { (attributes.url? ? :url : :content) => attributes }
      end

      attributes.each { |k,v| send "#{k}=", v }
    end

    def content
      @content ||= open(url, &:read)
    end

    def lines
      @lines ||= content.split
    end

    def contents
      lines.collect do |path|
        FileScheduler::URL.new :path => path, :url => full_url(path)
      end.delete_if(&:hidden?)
    end

    def full_url(path)
      URI.join url, path if url
    end

  end
end
