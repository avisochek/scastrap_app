Rails.application.routes.draw do
  get '/' => 'application#home'

  get '/clusters' => 'clusters#home'
  get '/clusters/city_menu' => 'clusters#city_menu'
  get '/clusters/request_type_menu/:city_id' => 'clusters#request_type_menu'
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
  get '/api/city_exists/:id_' => 'api#city_exists?'
  get '/api/street_exists/:id_'=> 'api#street_exists?'
  get '/api/batch_exists/:id_'=> 'api#batch_exists?'

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

end
