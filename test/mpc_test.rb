require "test_helper"

class MpcTest < MiniTest::Unit::TestCase

  def setup
    TCPSocket.any_instance.stubs(:puts).returns(nil)    
    @mpc = Mpc.new
  end

  def test_gets_raises_an_exception_on_ACK_response
    TCPSocket.any_instance.stubs(:gets).returns("ACK [5@0] {} unknown command \"asd\"\n")
    assert_raises(ArgumentError){
      @mpc.send(:send_command, "asd")
    }
  end

  def test_gets_outputs_empty_string_on_OK_response
    TCPSocket.any_instance.stubs(:gets).returns("OK\n")
    assert_equal("", @mpc.stop )
  end
end