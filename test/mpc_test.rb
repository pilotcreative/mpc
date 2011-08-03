require "test_helper"

class MpcTest < MiniTest::Unit::TestCase

  def setup
    TCPSocket.any_instance.stubs(:puts).returns(nil)    
    @mpc = Mpc.new
  end
end