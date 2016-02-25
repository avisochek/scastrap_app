require 'test_helper'

class ClustersControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "h1","Select a Request Type Below"
  end
  test "should get index" do
    get :index , :request_type_id=>1
    assert_response :success
    assert_select "h3","Select a Cluster Below to View Details"
    assert_select "h1",RequestType.find(1).name
  end
  test "should get show" do
    cluster_id=1
    get :show , :cluster_id=>cluster_id
    assert_response :success
    assert_select "h1",Cluster.find(cluster_id).request_type.name
  end
end
