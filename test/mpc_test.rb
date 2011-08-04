require "test_helper"

class MpcTest < MiniTest::Unit::TestCase

  def setup
    @socket_mock = stub("TCPSocket", :puts => nil, :gets => nil, :close => nil)
    @mpc = Mpc.new
    @mpc.stubs(:socket).returns(@socket_mock)
    @mpc.connect
  end

  def test_library_raises_error_if_there_is_no_connection
    @mpc.disconnect
    assert_raises(StandardError){
      @mpc.play
    }    
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

  def test_status_outputs_propper_hash
    @mpc.stubs(:get_response).returns("volume: -1\nrepeat: 0\nrandom: 0\nsingle: 0\nconsume: 0\nplaylist: 43\nplaylistlength: 41\nxfade: 0\nstate: stop\nsong: 17\nsongid: 17\nnextsong: 18\nnextsongid: 18\n")
    assert_equal({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"}, @mpc.send(:status) )
  end
end