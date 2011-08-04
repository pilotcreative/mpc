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
    @socket = nil
  end

  def play
    send_command "play"
  end

  def playing?
    status[:state] == "play"
  end

  def stop
    send_command "stop"
  end

  def stopped?
    status[:state] == "stop"
  end

  def pause
    send_command "pause 1"
  end

  def paused?
    status[:state] == "pause"
  end

  def next
    send_command "next"
  end

  def previous
    send_command "previous"
  end

  def random(state = nil)
    state ||= bool_to_int(!random?)
    send_command "random #{state}"
  end

  def random?
    status[:random] == "1"
  end

  def repeat(state = nil)
    state ||= bool_to_int(!repeat?)
    send_command "repeat #{state}"
  end

  def repeat?
    status[:repeat] == "1"
  end

  def volume(level = nil)
    set_volume(level) if level
    get_volume
  end

  def volume_up
    set_volume(volume.to_i + 20)
  end

  def volume_down
    set_volume(volume.to_i - 20)
  end

  private

  def get_volume
    status[:volume]
  end

  def set_volume(level)
    level = 0 if level < 0
    level = 100 if level > 100
    send_command "setvol #{level.to_s}"
  end

  def socket
    TCPSocket.new(@host, @port)
  end

  def gets_from_socket
    @socket.gets
  end

  def send_command(command)
    raise StandardError unless @socket
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

  def to_hash(string)
    output = Hash.new
    string.each_line do |line|
      key, value = line.chomp.split(": ", 2)
      output[key.to_sym] = value
    end
    output
  end

  def status
    to_hash(send_command("status"))
  end

  def bool_to_int(bool)
    bool == true ? 1 : 0
  end
end
