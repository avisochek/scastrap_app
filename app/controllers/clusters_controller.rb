class ClustersController < ApplicationController
  def home
  end
  def city_menu
    @cities=City.where.not :id_ =>0
    render :json => {:cities => @cities}
  end
  def request_type_menu
    @request_types=RequestType.where(:city_id=>params[:city_id])
    render :json => {:request_types => @request_types}
  end
  def cluster_menu
    request_type_id=params[:request_type_id]
    @clusters=Cluster.where(:request_type_id=>params[:request_type_id]).order(score: :desc)
    @request_type_name=RequestType.where(:id_=>params[:request_type_id]).first.name
    render :json => {:clusters => @clusters, :request_type_name => @request_type_name}
  end
  def show_cluster
    @cluster=Cluster.find(params[:cluster_id])
    @issues=Cluster.find(params[:cluster_id]).issues
    render :json => {:cluster => @cluster, :issues => @issues}
  end
end
