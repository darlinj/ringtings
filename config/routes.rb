ActionController::Routing::Routes.draw do |map|
  map.resources  :demo_callplans, :only => [:index, :create, :update]
  map.resources  :callplans, :only => [:show]
  
  #map.resources  :freeswitch, :only => [:index, :create]

  map.sign_up  'sign_up',
    :controller => 'users',
    :action     => 'new'

  map.sign_out 'sign_out',
    :controller => 'sessions',
    :action     => 'destroy',
    :method     => :delete

  map.resources :try_it, :only=>[:create]
  map.connect 'home', :controller => 'home', :action => 'index'
  map.connect 'secret_stuff', :controller => 'secret', :action => 'index'
  #map.connect 'demo_callplan/', :controller => 'tryit', :action => 'index'
  #map.connect 'demo_callplan/create', :controller => 'demo_callplan', :action => 'create'
  #map.connect 'demo_callplan/update', :controller => 'demo_callplan', :action => 'update'
  map.connect 'freeswitch/callplan', :controller => 'freeswitch', :action => 'callplan'
  map.connect 'freeswitch/ivr_menus', :controller => 'freeswitch', :action => 'ivr_menus'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
