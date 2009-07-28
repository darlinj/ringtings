# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_playpen_session',
  :secret      => '3470e8aad5133151bf0b699c99a9d8bea4f00ed02d3df5e1175f226c0e1cddc8b272e2fc1e2f4673897ca7a8fa2a9889b405394933a9240f8a534e7463c0d80d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
