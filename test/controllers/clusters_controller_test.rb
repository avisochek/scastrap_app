require 'test_helper'
require 'json'

class ClustersControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "h1","Clusters!"
  end
  test "should get request types" do
    get :request_type_menu
    assert_response :success
  end
  test "should get clusters" do
    request_type_id=1
    get :cluster_menu, :request_type_id=>request_type_id
    assert_response :success
    assert_equal request_type_id, JSON.parse(@response.body)["clusters"][0]["request_type_id"]
  end
  test "should get show cluster" do
    cluster_id=1
    get :show_cluster , :cluster_id=>cluster_id
    assert_response :success
    assert_not_nil cluster_id, JSON.parse(@response.body)["issues"][0]
  end
end
