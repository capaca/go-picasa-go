# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_image-gallery_session',
  :secret      => '8e4be915c1cf494cf6f30cb0bd03c5d84c2d24dcbf4bbd0db2bffb6fce7497c1f15cdbe77443836586f3de91957bb3d17ec27c9c567b92cd3215fceb393488d2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
