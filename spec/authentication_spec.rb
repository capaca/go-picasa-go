require 'spec_helper'

describe 'Picasa::Authentication' do
  it 'should authenticate user returning the authorization token' do
    mock_authentication
    
    auth_token = Picasa::Authentication.authenticate 'bandmanagertest', '$bandmanager$'
    auth_token.should_not be_nil
    auth_token.should_not be_empty
  end
  
  it 'should raise an exception in case of authorization failure' do
    mock_authentication_failure
    
    lambda {
      Picasa::Authentication.authenticate 'bandmanagertest', 'wrong_password'
    }.should raise_error
  end
  
  it 'should upgrade the auth sub token' do
    mock_upgrade_token
    
    auth_token = Picasa::Authentication.upgrade_token '1/fdd4JCZKduvrRsaRIe25dbhyEHB21iIDuz_PzhSiL_o'
    auth_token.should_not be_nil
    auth_token.should_not be_empty
    auth_token.should_not match /Token=/
  end
  
  it 'should raise an exception in case of not being able to upgrade the token' do
    mock_upgrade_token_failure
    
    lambda {
      auth_token = Picasa::Authentication.upgrade_token 'wrong_token'
    }.should raise_error
  end
end
