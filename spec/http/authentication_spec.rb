require 'spec_helper'

describe 'Picasa::HTTP::Authentication' do
  include Picasa::Util
  
  it 'should do a post to authenticate' do
    resp, body = Picasa::HTTP::Authentication.authenticate 'bandmanagertest@gmail.com', '$bandmanager$'
    resp.success?.should be_true
    resp.message_OK?.should be_true
  
    auth_token = extract_auth_token body
    auth_token.should_not be_nil
    auth_token.should_not be_empty
  end
  
  it 'should do a get to upgrade the single request auth sub token' do
    mock_upgrade_token
    
    resp, body = Picasa::HTTP::Authentication.upgrade_token "1/PdLJ8d-qXVcqTQg2fCd6xaXc6TRgIetjXFL1eZD6xGk"
    resp.success?.should be_true
    resp.code.should == "200"
    
    body.should_not be_empty
    body.should match /Token=/ 
  end
end
