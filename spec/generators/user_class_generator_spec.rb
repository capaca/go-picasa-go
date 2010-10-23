require 'spec_helper'

describe 'UserClassGenerator' do
  
  FILE_NAME = 'my_user.rb'
  
  before :each do
    mock_authentication
    if File.exist? FILE_NAME
      File.delete FILE_NAME
    end
  end
  
  it 'should generate the user class file' do
    dir = Dir.open '.'
    dir.entries.should_not include 'my_user.rb'
    
    system "go-picasa-go user_class MyUser bandmanagertest '$bandmanager$'"
    
    dir.entries.should include 'my_user.rb'
  end
  
  it 'should not generate the user class if it doesnt inform the right parameters' do
    dir = Dir.open '.'
    dir.entries.should_not include 'my_user.rb'
    
    system "go-picasa-go user_class MyUser bandmanagertest"
    
    dir.entries.should_not include 'my_user.rb'
  end
  
  it 'should not generate the user class if it cannot authenticate' do
    dir = Dir.open '.'
    dir.entries.should_not include 'my_user.rb'
    
    system "go-picasa-go user_class MyUser bandmanagertest wrong_password"
    
    dir.entries.should_not include 'my_user.rb'
  end
end
