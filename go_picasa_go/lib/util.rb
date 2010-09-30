module Picasa::Util
  def extract_auth_token body
    body[/Auth=(.*)/, 1]
  end
end
