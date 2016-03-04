require 'test_helper'
require 'json'

class ApiTest < ActionDispatch::IntegrationTest
  test "assure users can't get in without proper key" do
    get '/api/issue_exists/1'
    assert_response 403
    get '/api/issue_exists/1?key=xxxxyyyljwfaoi'
    assert_response 403
  end

  ## test for queries of last resource id
  test "get_last_cluster_id" do
    get '/api/latest_cluster_id?key=xxxx'
    assert_response 200
    assert_equal 1,JSON.parse(@response.body)['latest_cluster_id']
  end

  test "get_last_batch_id" do
    get '/api/latest_batch_id?key=xxxx'
    assert_response 200
    assert_equal 1,JSON.parse(@response.body)['latest_batch_id']
  end

  ## test api get requests for querying weather resource exists
  test "batch_exists? returns true when resource exists" do
    get '/api/batch_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "batch_exists? returns false when resource does not exist" do
    get '/api/batch_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end
  test "street_exists? returns true when resource exists" do
    get '/api/street_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "street_exists? returns false when resource does not exist" do
    get '/api/street_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end
  test "city_exists? returns true when resource exists" do
    get '/api/city_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "city_exists? returns false when resource does not exist" do
    get '/api/city_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end
  test "issue_exists? returns true when resource exists" do
    get '/api/issue_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "issue_exists? returns false when resource does not exist" do
    get '/api/issue_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end
  test "cluster_exists? returns true when resource exists" do
    get '/api/cluster_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "cluster_exists? returns false when resource does not exist" do
    get '/api/cluster_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end
  test "request_type_exists? returns true when resource exists" do
    get '/api/request_type_exists/1?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "true", result['message']
  end
  test "request_type_exists? returns false when resource does not exist" do
    get '/api/request_type_exists/9?key=xxxx'
    assert_response(200)
    result = JSON.parse(@response.body)
    assert_equal "false", result['message']
  end


  test "update_issue updates issues" do
    status = "closed"
    street_id = 2
    patch "/api/update_issue?key=xxxx", :issue => {:id_=>1,
                                                   :street_id=>street_id,
                                                   :status=>status}
    assert_response(201)
    assert_equal status, Issue.find(1)[:status]
    assert_equal street_id, Issue.find(1)[:street_id]
  end

  test "create city creates cities" do
    id=6
    lat = 42
    lng = -72
    name = "New York, NY"
    post '/api/create_city?key=xxxx', :city => {:id_=>id,
                                                :name=>name,
                                                :lat=>lat,
                                                :lng=>lng}
    assert_response(201)
    assert_equal City.find(id).name,name
  end

  test "create_issue creates issues" do
    id=6
    request_type_id= 1
    created_at= "2016-02-23T13:26:28-05:00"
    status= "acknowledged"
    lng= 52.1994138
    lat= -105.1363869
    street_id= 1
    post "/api/create_issue?key=xxxx", :issue => {:id_=>id,
                                       :request_type_id=>request_type_id,
                                       :created_at=>created_at,
                                       :status=>status,
                                       :lng=>lng,
                                       :lat=>lat,
                                       :street_id=>1}
    assert_response(201)
    assert_equal Issue.find(id).request_type_id, request_type_id
    assert_equal Issue.find(id).created_at,created_at
    assert_equal Issue.find(id).status,status
    assert_equal Issue.find(id).lng,lng
    assert_equal Issue.find(id).lat,lat
    assert_equal Issue.find(id).street_id,street_id
  end

  test "create cluster creates clusters" do
    id=2
    score=10
    request_type_id=1
    post '/api/create_cluster?key=xxxx',:cluster => {:id_=>id,
                                                    :request_type_id=>request_type_id,
                                                    :score=>score}
    assert_response(201)
    assert_equal Cluster.find(id).score , score
    assert_equal Cluster.find(id).request_type_id , request_type_id
  end

  test "create_request_type creates request types" do
    id=2
    name="asdf"
    post '/api/create_request_type?key=xxxx',:request_type => {:id_=>id,
                                                    :name => name}
    assert_response(201)
    assert_equal  RequestType.find(id).name,name
  end

  test "create_batch creates batches" do
    id=2
    created_at="2016-02-23T13:26:28-05:00"
    post '/api/create_batch?key=xxxx',:batch => {:id_=>id,
                                                    :created_at => created_at}
    assert_response(201)
    assert_equal Batch.find(id).created_at,created_at
  end

  test "create_cluster_issue creates clusters_issues" do
    issue_id=1
    cluster_id=1
    post '/api/create_cluster_issue?key=xxxx',:cluster_issue => {:issue_id=>issue_id,
                                                    :cluster_id => cluster_id}
    assert_response(201)
    #assert_operator ClustersIssues.all.length,:>,0 ## this is all I know how to do for now
  end
end
