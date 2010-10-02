module MockHelper
  def mock_authentication
    resp_arr = build_resp_mock_array "200", "OK", 
      "SID=DQAAAHgAAAAPNCL6mdI-GHhLWNxobTWfGwlWtFFVjZDatJrrcdx6UxlaP4WCll4yj0c_JEHcEp6RhracBN5ZYLhtmwpOgzMy4FlpJnNTuBAYwaraMmYdGIHBTqQKlOXTFHj-_igz9bF5vVaTOKM1r4VC4DOVadpad81CH86sWw6rzjNbRluYiw\nLSID=DQAAAHsAAABUvbolIC84hXe4_1zu17gr4ZkReQJvsnWyI5Ntivn4VfNaXClPbafabGnT11_gWOahnzmYL0YubbAlos6pghoXwVp68RswbHlWMj3mC0e5UnqpHBZmUkljb5FXjt-XfhRAYkGjxB1LqPre3wcAPSWaoB-nJjoRS2yI6lHoqDTjWA\nAuth=DQAAAHoAAABUvbolIC84hXe4_1zu17gr4ZkReQJvsnWyI5Ntivn4VfNaXClPbafabGnT11_gWOZzriSF26k49zZh1xeMgE67UkzjY7Y1qnlH8_gAyc_YEYoSwk42-40BDnHi8d7bU-mlt5oL53qfS2Eno1mZvEfgGxQaHNUFoXL-xXaLsawbcQ\n"
    
    Picasa::HTTP::Authentication.stub!(:authenticate).and_return(resp_arr)
  end
  
  def mock_authentication_failure
    resp_arr = build_resp_mock_array "403", "Forbidden", "Error=BadAuthentication\n"
    Picasa::HTTP::Authentication.stub!(:authenticate).and_return(resp_arr)
  end
  
  def mock_post_album
    resp_arr = build_resp_mock_array "201", "Created", 
      "<?xml version='1.0' encoding='UTF-8'?><entry xmlns='http://www.w3.org/2005/Atom' xmlns:gphoto='http://schemas.google.com/photos/2007' xmlns:media='http://search.yahoo.com/mrss/'><id>http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881</id><published>2010-10-02T21:29:41.000Z</published><updated>2010-10-02T21:29:41.409Z</updated><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'/><title type='text'>testing title</title><summary type='text'>testing summary</summary><rights type='text'>public</rights><link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://picasaweb.google.com/data/feed/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='alternate' type='text/html' href='http://picasaweb.google.com/bandmanagertest/TestingTitle'/><link rel='self' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='edit' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/1'/><link rel='http://schemas.google.com/acl/2007#accessControlList' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/acl'/><author><name>BandManager Test</name><uri>http://picasaweb.google.com/bandmanagertest</uri></author><gphoto:id>5523564086023148881</gphoto:id><gphoto:name>TestingTitle</gphoto:name><gphoto:location>testing location</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>1286054981000</gphoto:timestamp><gphoto:numphotos>0</gphoto:numphotos><gphoto:numphotosremaining>1000</gphoto:numphotosremaining><gphoto:bytesUsed>0</gphoto:bytesUsed><gphoto:user>bandmanagertest</gphoto:user><gphoto:nickname>BandManager Test</gphoto:nickname><gphoto:commentingEnabled>true</gphoto:commentingEnabled><gphoto:commentCount>0</gphoto:commentCount><media:group><media:content url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/TestingTitle.jpg' type='image/jpeg' medium='image'/><media:credit>BandManager Test</media:credit><media:description type='plain'>testing summary</media:description><media:keywords/><media:thumbnail url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/s160-c/TestingTitle.jpg' height='160' width='160'/><media:title type='plain'>testing title</media:title></media:group></entry>"
    
    Picasa::HTTP::Album.stub!(:post_album).and_return(resp_arr)
  end
  
  def mock_get_album
    resp_arr = build_resp_mock_array "200", "OK", 
      "<?xml version='1.0' encoding='UTF-8'?><entry xmlns='http://www.w3.org/2005/Atom' xmlns:gphoto='http://schemas.google.com/photos/2007' xmlns:media='http://search.yahoo.com/mrss/'><id>http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881</id><published>2010-10-02T21:29:41.000Z</published><updated>2010-10-02T21:29:41.409Z</updated><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'/><title type='text'>testing title</title><summary type='text'>testing summary</summary><rights type='text'>public</rights><link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://picasaweb.google.com/data/feed/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='alternate' type='text/html' href='http://picasaweb.google.com/bandmanagertest/TestingTitle'/><link rel='self' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='edit' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/1'/><link rel='http://schemas.google.com/acl/2007#accessControlList' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/acl'/><author><name>BandManager Test</name><uri>http://picasaweb.google.com/bandmanagertest</uri></author><gphoto:id>5523564086023148881</gphoto:id><gphoto:name>TestingTitle</gphoto:name><gphoto:location>testing location</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>1286054981000</gphoto:timestamp><gphoto:numphotos>0</gphoto:numphotos><gphoto:numphotosremaining>1000</gphoto:numphotosremaining><gphoto:bytesUsed>0</gphoto:bytesUsed><gphoto:user>bandmanagertest</gphoto:user><gphoto:nickname>BandManager Test</gphoto:nickname><gphoto:commentingEnabled>true</gphoto:commentingEnabled><gphoto:commentCount>0</gphoto:commentCount><media:group><media:content url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/TestingTitle.jpg' type='image/jpeg' medium='image'/><media:credit>BandManager Test</media:credit><media:description type='plain'>testing summary</media:description><media:keywords/><media:thumbnail url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/s160-c/TestingTitle.jpg' height='160' width='160'/><media:title type='plain'>testing title</media:title></media:group></entry>"
    
    Picasa::HTTP::Album.stub!(:get_album).and_return(resp_arr)
  end
  
  def mock_get_album_failure
    resp_arr = build_resp_mock_array "404", "NotFound", "Error=NotFound\n", false
    Picasa::HTTP::Album.stub!(:get_album).and_return(resp_arr)
  end
  
  def mock_update_album params
    resp_arr = build_resp_mock_array "200", "OK", 
      "<?xml version='1.0' encoding='UTF-8'?><entry xmlns='http://www.w3.org/2005/Atom' xmlns:gphoto='http://schemas.google.com/photos/2007' xmlns:media='http://search.yahoo.com/mrss/'><id>http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881</id><published>2010-10-02T21:29:41.000Z</published><updated>2010-10-02T21:29:41.409Z</updated><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#album'/><title type='text'>#{params[:title]}</title><summary type='text'>#{params[:summary]}</summary><rights type='text'>public</rights><link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://picasaweb.google.com/data/feed/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='alternate' type='text/html' href='http://picasaweb.google.com/bandmanagertest/TestingTitle'/><link rel='self' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881'/><link rel='edit' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/1'/><link rel='http://schemas.google.com/acl/2007#accessControlList' type='application/atom+xml' href='http://picasaweb.google.com/data/entry/api/user/bandmanagertest/albumid/5523564086023148881/acl'/><author><name>BandManager Test</name><uri>http://picasaweb.google.com/bandmanagertest</uri></author><gphoto:id>5523564086023148881</gphoto:id><gphoto:name>TestingTitle</gphoto:name><gphoto:location>#{params[:location]}</gphoto:location><gphoto:access>public</gphoto:access><gphoto:timestamp>1286054981000</gphoto:timestamp><gphoto:numphotos>0</gphoto:numphotos><gphoto:numphotosremaining>1000</gphoto:numphotosremaining><gphoto:bytesUsed>0</gphoto:bytesUsed><gphoto:user>bandmanagertest</gphoto:user><gphoto:nickname>BandManager Test</gphoto:nickname><gphoto:commentingEnabled>true</gphoto:commentingEnabled><gphoto:commentCount>0</gphoto:commentCount><media:group><media:content url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/TestingTitle.jpg' type='image/jpeg' medium='image'/><media:credit>BandManager Test</media:credit><media:description type='plain'>testing summary</media:description><media:keywords/><media:thumbnail url='http://lh3.ggpht.com/_Eo7DPaDqPZg/TKekRWmD1VE/AAAAAAAAAxw/uc_G0pxsLb4/s160-c/TestingTitle.jpg' height='160' width='160'/><media:title type='plain'>testing title</media:title></media:group></entry>"
    
    Picasa::HTTP::Album.stub!(:update_album).and_return(resp_arr)
  end
  
  def mock_delete_album
    resp_arr = build_resp_mock_array "200", "OK", ""  
    Picasa::HTTP::Album.stub!(:delete_album).and_return(resp_arr)
  end
  
  private 
  
  def build_resp_mock_array code, message, data, success = true
    resp_mock = mock()
    resp_mock.stub!(:code).and_return(code)
    resp_mock.stub!(:message).and_return(message)
    resp_mock.stub!(:success?).and_return(success)
        
    resp_arr = [resp_mock, data]
  end
end
