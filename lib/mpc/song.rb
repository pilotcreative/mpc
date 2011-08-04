class Mpc::Song

  def initialize(options)
    @options = options
  end

  def to_s
    if @options[:Artist].empty? || @options[:Title].empty?
      @options[:file]
    else
      "#{@options[:Artist]} - #{@options[:Title]}"
    end
  end
end