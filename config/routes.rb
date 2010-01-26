ActionController::Routing::Routes.draw do |map|
  map.resources  :demo_callplans, :only => [:index, :create, :update, :show]
  map.resources  :callplans, :only => [:show, :update]
  map.resources  :ivr_menu_entries#, :only => [:create, :destroy]
  map.resources  :ivr_menu_entry_prototypes, :only => [:index]

  map.user 'users/new', :controller => 'users', :action => 'new'
  map.user 'users', :controller => 'users', :action => 'create'

  map.sign_up  'sign_up',
    :controller => 'users',
    :action     => 'new'

  map.sign_out 'sign_out',
    :controller => 'sessions',
    :action     => 'destroy',
    :method     => :delete


  map.resources :try_it, :only=>[:create]
  map.connect 'demo_callplans/generate_full_demo_callplan/:id', :controller => 'demo_callplans', :action => 'generate_full_demo_callplan'
  map.connect 'demo_callplans/create_user/:id', :controller => 'demo_callplans', :action => 'create_user'
  map.connect 'home', :controller => 'home', :action => 'index'
  map.connect 'secret_stuff', :controller => 'secret', :action => 'index'
  map.connect 'freeswitch/callplan', :controller => 'freeswitch', :action => 'callplan'
  map.connect 'freeswitch/ivr_menus', :controller => 'freeswitch', :action => 'ivr_menus'
  map.root :controller => 'home'
end
