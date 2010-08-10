require "test_helper"
class MpcTest < Test::Unit::TestCase
  
  def setup
    @mpc = Mpc.new
    TCPSocket.any_instance.stubs(:puts).returns(nil)
  end
  
  test "gets raises an exception on ACK response" do
    TCPSocket.any_instance.stubs(:gets).returns("ACK [5@0] {} unknown command \"asd\"\n")
    assert_raise(Mpc::Exception) do 
      @mpc.send(:puts,'asd')
    end
  end
  
  test "gets outputs empty string on OK response " do
    TCPSocket.any_instance.stubs(:gets).returns("OK\n")
    assert_equal("",@mpc.stop )
  end

  test "status outputs propper hash" do
    @mpc.stubs(:gets).returns("volume: -1\nrepeat: 0\nrandom: 0\nsingle: 0\nconsume: 0\nplaylist: 43\nplaylistlength: 41\nxfade: 0\nstate: stop\nsong: 17\nsongid: 17\nnextsong: 18\nnextsongid: 18\n")
    assert_equal({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"},@mpc.send(:status) )
  end

  test "random without state should send request with opposite value" do
    @mpc.stubs(:status).returns({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"})
    @mpc.expects(:puts).with('random 1')
    @mpc.random
  end

  test "random with state should send request with given value" do
    @mpc.stubs(:status).returns({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"})
    @mpc.expects(:puts).with('random 0')
    @mpc.random(0)
  end

  test "repeat without state should send request with opposite value" do
    @mpc.stubs(:status).returns({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"})
    @mpc.expects(:puts).with('repeat 1')
    @mpc.repeat
  end

  test "repeat with state should send request with given value" do
    @mpc.stubs(:status).returns({:songid=>"17", :state=>"stop", :single=>"0", :volume=>"-1", :nextsong=>"18", :consume=>"0", :nextsongid=>"18", :playlist=>"43", :repeat=>"0", :song=>"17", :playlistlength=>"41", :random=>"0", :xfade=>"0"})
    @mpc.expects(:puts).with('repeat 0')
    @mpc.repeat(0)
  end

  test "set_volume with volume in propper range should not raise exception" do
    @mpc.expects(:puts).with('setvol 100')
    @mpc.set_volume(100)
  end

  test "setvol with volume out of range should raise exception" do
    assert_raise(Mpc::Exception) do
      @mpc.set_volume(200)
    end
  end

  test "seek without song_position seeks current song" do
    @mpc.stubs(:current_song).returns({:date=>"2008", :track=>"4", :album=>"One Kind Favor", :genre=>"Blues", :time=>"190", :file=>"Kuba's Music/B.B. King - One Kind Favor/04. B.B. King - How Many More Years.mp3", :pos=>"3", :title=>"How Many More Years", :id=>"3", :albumartist=>"B.B. King", :artist=>"B.B. King"})
    @mpc.expects(:puts).with('seek 3 130')
    @mpc.seek(130)
  end

  test "seek with song_position seeks given song" do
    @mpc.stubs(:current_song).returns({:date=>"2008", :track=>"4", :album=>"One Kind Favor", :genre=>"Blues", :time=>"190", :file=>"Kuba's Music/B.B. King - One Kind Favor/04. B.B. King - How Many More Years.mp3", :pos=>"3", :title=>"How Many More Years", :id=>"3", :albumartist=>"B.B. King", :artist=>"B.B. King"})
    @mpc.expects(:puts).with('seek 11 20')
    @mpc.seek(20,11)
  end

  test "find with wrong type should raise exception" do
    assert_raise(Mpc::Exception) do
      @mpc.find('wrong_type')
    end
  end

  test "find with correct type but with empty string should raise exception" do
    assert_raise(Mpc::Exception) do
      @mpc.find('artist',"")
    end
  end

  test "find with correct type and with string should return hash with songs" do

  end

  test "list_library should return tree" do
    @mpc.stubs(:get_paths).returns(["Abra Dab/Miasto Jest Nasze/ABRADAB - Bezposrednio.mp3",
    "Abra Dab/Miasto Jest Nasze/miasto jest nasze (3).mp3",
    "iTunes/iTunes Music/02. Aaliyah/Romeo must die/06 Are You Feelin Me.mp3",
    "iTunes/iTunes Music/07. Dave Bing ft. Lil' Mo/Romeo must die/12 Someone Gonna Die Tonight.mp3"])
    @root = Tree::TreeNode.new('/')
    @first_node = Tree::TreeNode.new('Abra Dab')
    
    @folder = Tree::TreeNode.new('Miasto Jest Nasze')
    @folder << Tree::TreeNode.new('ABRADAB - Bezposrednio.mp3')
    @folder << Tree::TreeNode.new('miasto jest nasze (3).mp3') 
    
    @first_node << @folder
    @root << @first_node
    
    @second_node = Tree::TreeNode.new('iTunes')
    @folder = Tree::TreeNode.new('iTunes Music')
    @first_subfolder = Tree::TreeNode.new('02. Aaliyah')
    @element = Tree::TreeNode.new('Romeo must die')
    @mp3 = Tree::TreeNode.new('06 Are You Feelin Me.mp3')
    @element << @mp3
    @first_subfolder << @element
    @second_subfolder = Tree::TreeNode.new("07. Dave Bing ft Lil' Mo")
    @element = Tree::TreeNode.new('Romeo must die')
    @mp3 = Tree::TreeNode.new('12 Someone Gonna Die Tonight.mp3')
    @element << @mp3
    @second_subfolder << @element
    
    @folder << @first_subfolder
    @folder << @second_subfolder
    @second_node << @folder
    @root << @second_node
    
    assert_equal(@root.to_s,@mpc.list_library.to_s)
  end
end