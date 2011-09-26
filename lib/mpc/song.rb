class Mpc
  class Song

    def initialize(options)
      @options = options
    end

    def artist
      @options[:Artist] || ""
    end

    def title
      @options[:Title] || ""
    end

    def album
      @options[:Album] || ""
    end

    def to_s
      if !artist and !title
        @options[:file]
      else
        "#{artist} - #{title}"
      end
    end
  end
end