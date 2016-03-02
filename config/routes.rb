Rails.application.routes.draw do
  get '/' => 'application#home'

  get '/clusters' => 'clusters#home'
  get '/clusters/request_type_menu' => 'clusters#request_type_menu'
  get '/clusters/cluster_menu/:request_type_id' => 'clusters#cluster_menu'
  get '/clusters/:cluster_id' => 'clusters#show_cluster'


  ######
  ######
  ######
  ## api
  ### check first if resource already exists
  get '/api/issue_exists/:id_' => 'api#issue_exists?'
  get '/api/cluster_exists/:id_' => 'api#cluster_exists?'
  get '/api/request_type_exists/:id_' => 'api#request_type_exists?'
  get 'api/city_exists/:id_' => 'api#city_exists?'

  ### check for latest id for reference
  get 'api/latest_cluster_id' => 'api#get_latest_cluster_id'
  get 'api/latest_batch_id' => 'api#get_latest_batch_id'

  ### update existing resources
  patch '/api/update_issue' => 'api#update_issue'
  ## for now, clusters and request types are assumed to be static
  ## once uploaded, so no need for these routes
  #patch '/api/update_cluster/:id_' => 'api#update_cluster'
  #patch '/api/update_request_type/:id_' => 'api#update_issue'

  ### create new resources
  post '/api/create_city' => 'api#create_city'
  post '/api/create_issue' => 'api#create_issue'
  post '/api/create_cluster' => 'api#create_cluster'
  post '/api/create_request_type' => 'api#create_request_type'
  post '/api/create_batch' => 'api#create_batch'
  post '/api/create_cluster_issue' => 'api#create_cluster_issue'

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
