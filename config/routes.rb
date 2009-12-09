ActionController::Routing::Routes.draw do |map|
  # AUTH
  map.resource :user_session
  map.login    'login',    :controller => "user_sessions", :action => "new"
  map.logout   'logout',   :controller => "user_sessions", :action => "destroy"
  map.register 'register', :controller => "users",         :action => "new"

  # USERS
  map.resource :account, :controller => "users"
  map.resources :users
  
  # SPECIAL PAGES
  map.root :controller => 'special', :action => 'home'
  map.about 'about', :controller => 'special', :action => 'about'
end
