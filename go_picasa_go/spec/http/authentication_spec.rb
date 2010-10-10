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
end
