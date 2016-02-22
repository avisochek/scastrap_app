class ClustersController < ApplicationController
  def home
    @request_types=RequestType.where.not :id_ => 0
  end
  def index
    request_type_id=params[:request_type_id]
    @clusters=Cluster.where(:request_type_id=>params[:request_type_id]).order(score: :desc)
    @request_type_name=RequestType.where(:id_=>params[:request_type_id]).first.name
  end
  def show
    @cluster=Cluster.find(params[:cluster_id])
    @issues=Cluster.find(params[:cluster_id]).issues
  end
end
