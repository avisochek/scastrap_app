require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  test "assure users can't get in without proper key" do
    get '/api/issue_exists/1'
    assert_response 403
    get '/api/issue_exists/1?key=xxxxyyyljwfaoi'
    assert_response 403
  end

  ## test api get requests for querying weather resource exists
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
    street_name = "Whalley Avenue"
    patch "/api/update_issue?key=xxxx", :issue => {:id_=>1,
                                                   :street_name=>street_name,
                                                   :status=>status}
    assert_response(201)
    assert_equal status, Issue.find(1)[:status]
    assert_equal street_name, Issue.find(1)[:street_name]
  end

  test "create_issue creates issues" do
    id=6
    request_type_id= 1
    cluster_id= 1
    created_at= "2016-02-23T13:26:28-05:00"
    status= "acknowledged"
    lng= 52.1994138
    lat= -105.1363869
    street_name= "Chapel Street"
    post "/api/create_issue?key=xxxx", :issue => {:id_=>id,
                                       :request_type_id=>request_type_id,
                                       :created_at=>created_at,
                                       :status=>status,
                                       :lng=>lng,
                                       :lat=>lat,
                                       :street_name=>street_name,
                                       :cluster_id=>cluster_id}
    assert_response(201)
    assert_equal Issue.find(id).request_type_id, request_type_id
    assert_equal Issue.find(id).cluster_id,cluster_id
    assert_equal Issue.find(id).created_at,created_at
    assert_equal Issue.find(id).status,status
    assert_equal Issue.find(id).lng,lng
    assert_equal Issue.find(id).lat,lat
    assert_equal Issue.find(id).street_name,street_name
  end

  test "create cluster creates clusters" do
    id=2
    score=10
    request_type_id=1
    post '/api/create_cluster?key=xxxx',cluster => {:id_=>id,
                                                    :request_type_id=>request_type_id,
                                                    :status=>status}
    assert_equal Cluster.find(id).request_type_id,request_type_id
    assert_equal Cluster.find(id).request_type_id,request_type_id
  end

  test "create_request_type creates request types" do
    id=2
    name="asdf"
    post '/api/create_cluster?key=xxxx',cluster => {:id_=>id,
                                                    :name => name}
    assert_equal Cluster.find(id).name,name
  end
end
