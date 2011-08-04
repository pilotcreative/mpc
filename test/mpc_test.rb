require "test_helper"

class MpcTest < MiniTest::Unit::TestCase

  def setup
    @socket_mock = stub("TCPSocket", :puts => nil, :gets => nil)
    @mpc = Mpc.new
    @mpc.stubs(:socket).returns(@socket_mock)
    @mpc.connect
  end

  def test_gets_raises_an_exception_on_ACK_response
    @mpc.stubs(:gets_from_socket).returns("ACK [5@0] {} unknown command \"asd\"\n")
    assert_raises(ArgumentError){
      @mpc.send(:send_command, "asd")
    }
  end

  def test_gets_outputs_empty_string_on_OK_response
    @mpc.stubs(:gets_from_socket).returns("OK\n")
    assert_equal("", @mpc.stop )
  end
end