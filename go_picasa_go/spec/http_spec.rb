require 'http'

describe 'Picasa::HTTP' do
  it 'should do a post to authenticate' do
    Picasa::HTTP.authenticate '', ''
  end
end
