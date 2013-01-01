
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure' => 'sessions#failure', :as => :auth_failure
  match '/auth/facebook', :as => :facebook_login
