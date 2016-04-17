Rails.application.routes.draw do
  get '/' => 'application#home'
  get '/request_type_menu' => 'application#request_type_menu'

  ## clusters
  get '/clusters/get_clusters/:request_type_id' => 'clusters#get_clusters'

  ## issues
  get '/issues/get_issues/:request_type_id' => 'issues#get_issues'
  get 'issues/get_cluster/:cluster_id' => 'issues#get_cluster'

  ## streets
  get '/streets' => 'streets#home'
  get '/streets/ranking/:request_type_id' => 'streets#ranking'
  get '/streets/stats/:street_id' => 'streets#stats'

  ## feedback
  post '/feedback' => 'feedback#send_mail'

  ## api
  post '/api/create_city' => 'api#create_city'
  post '/api/create_request_type' => 'api#create_request_type'
  post '/api/create_batch' => 'api#create_batch'

  post '/api/bulk_upsert_street'=>'api#bulk_upsert_street'
  post '/api/bulk_upsert_issue' => 'api#bulk_upsert_issue'
  post '/api/bulk_upsert_cluster_issue' => 'api#bulk_upsert_cluster_issue'
  post '/api/bulk_upsert_cluster' => 'api#bulk_upsert_cluster'
end
