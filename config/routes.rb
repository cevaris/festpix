Rq::Application.routes.draw do

  match '/photo_sessions/d52efba0-c73f-11e3-9c1a-0800200c9a66' => 'photo_sessions#admin_show', via: [:get]
  match '/photos/:photo_slug' => 'photo#photo', via: [:get], as: 'photo'
  # match '/photo/:photo_id/:size' => 'photo#photo', via: [:get], as: 'photo_size'



  # match '/photo_session/search' => 'photo_sessions#search', via: [:get], as: 'search_sessions'
  # resources :email, :path => "pics"

  # match '/photo_sessions/:slug' => 'photo#photo', via: [:get], as: 'photo'
  resources :photo_sessions do
    match 'claim', to: 'photo_sessions#claim', via: [:get]
    # match '/:slug', to: 'photo_sessions#show',  via: [:get], as: 'photo_sessions_slug'
    
    # match 'pics', to: 'photo_sessions#email_new', via: [:get]
    # match 'pics', to: 'photo_sessions#email_create', via: [:post]
  end

  resources :events
  resources :event_images

  
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users, :only => [:show, :index]
  root :to => "home#index"



  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
