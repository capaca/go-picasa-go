require 'spec_helper'

describe 'Picasa::Authentication' do
  it 'should authenticate user returning the authorization token' do
    mock_authentication
    
    auth_token = Picasa::Authentication.authenticate 'bandmanagertest', '$bandmanager$'
    auth_token.should_not be_nil
    auth_token.should_not be_empty
  end
  
  it 'should raise an exception in casa of authorization failure' do
    mock_authentication_failure
    
    lambda {
      Picasa::Authentication.authenticate 'bandmanagertest', 'wrong_password'
    }.should raise_error
  end
end
