# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_allyourcells_session',
  :secret      => '88ff368cfa962ef1045953f7f11ad5a6a20424a77874df16794742ec52d71e54502fee6bfe8d881788e2a4386c9002f4ff828f0d45f0d780af4cd93be8e5ca51'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
