class Picasa::AuthSub
  include Picasa::HTTP::AlbumClient

  def initialize user_id, token
    @user_id = user_id
    @token = token
  end
  
  def upgrade token
    uri = URI.parse 'https://www.google.com/accounts/AuthSubSessionToken'
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true

    headers = {
      'Authorization' => "AuthSub token=\"#{token}\""
    }

    http.get uri.path, headers
  end

  def valid? token
    uri = URI.parse 'https://www.google.com/accounts/AuthSubTokenInfo'
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    headers = {"Authorization" => "AuthSub token=\"#{token}\""}
    http.get uri.path, headers
  end

  private

  def auth_header
    return {"Authorization" => "AuthSub token=\"#{@token}\""}
  end
end
