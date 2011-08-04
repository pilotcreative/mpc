require "socket"
class Mpc

  @@regexps = {
    "ACK"     => /\AACK \[(\d+)\@(\d+)\] \{(.*)\} (.+)\Z/,
    "OK"      => /\AOK\n\Z/,
    "FILE"    => /\Afile\:(.*)\Z/,
    "CONNECT" => /\AOK MPD (\d+)\.(\d+).(\d+)\n\Z/
  }

  attr_accessor :host, :port
  def initialize(host = "127.0.0.1", port = 6600)
    @host = host
    @port = port
  end

  def connect
    @socket = socket
    @socket.gets
  end

  def disconnect
    @socket.close
  end

  def play
    send_command "play"
  end

  def stop
    send_command "stop"
  end

  def pause
    send_command "pause 1"
  end

  def next
    send_command "next"
  end

  def previous
    send_command "previous"
  end

  private

  def socket
    TCPSocket.new(@host, @port)
  end

  def gets_from_socket
    @socket.gets
  end

  def send_command(command)
    @socket.puts(command)
    get_response
  end

  def get_response
    response = ""
    while line = gets_from_socket do
      if @@regexps["OK"].match(line)
        return response
      elsif error = @@regexps["ACK"].match(line)
        raise ArgumentError.new(line)
      else
        response << line
      end
    end
    response
  end
end
