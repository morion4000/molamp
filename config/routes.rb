Molamp::Application.routes.draw do
  resource :account, :controller => "users"
  resources :users
  resource :user_session
  #root :controller => "user_sessions", :action => "new"
  
  resources :albums
  resources :search
  #resources :artists
  resources :faq
  resources :privacy
  resources :tos

  match 'account/social' => 'users#social'

  match 'artists' => 'artists#index'
  
  match 'artists/:id' => 'artists#show', :constraints => { :id => /[^\/]*/ } #:id => /[0-9a-zA-Z.&+%]+/
  match 'artists/:artist/:album' => 'albums#show', :constraints => { :artist => /[^\/]*/, :album => /[^\/]*/ } #:artist => /[0-9a-zA-Z.&+%'_-]+/, :album => %r{[0-9a-zA-Z.&':()+/!-_]+}i
  match 'artists/:artist/_/:track' => 'tracks#show', :constraints => { :artist => /[^\/]*/, :track => /[^\/]*/ }

  match 'auth/facebook' => 'auth#facebook'
  match 'auth/lastfm' => 'auth#lastfm'
  match 'auth/facebook/logout' => 'auth#logout_facebook'
  match 'auth/lastfm/logout' => 'auth#logout_lastfm'
  
  match 'ajax/scrobble_mode' => 'ajax#scrobble_mode'
  match 'ajax/activity_mode' => 'ajax#activity_mode'
  match 'ajax/scrobble'      => 'ajax#scrobble'
  match 'ajax/activity'      => 'ajax#activity'
  match 'ajax/image'         => 'ajax#get_image'

  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
