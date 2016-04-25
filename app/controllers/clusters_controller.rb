class ClustersController < ApplicationController
  def get_clusters
    request_type=RequestType.find(params[:request_type_id])
    ## fetch the latest batch id
    @latest_batch=Batch.where(:city_id=>request_type[:city_id]).order(:id_=>:desc).first
    if @latest_batch
      @clusters = Cluster.where(
        :request_type_id=>params[:request_type_id],
        :batch_id=>@latest_batch[:id_]).order(:score=> :desc)
      render :json => {:clusters => @clusters,:batch=>@latest_batch}
    else
      render :json => {:clusters => []}
    end
  end
  def show_cluster
    @issues=Cluster.find(params[:cluster_id]).issues
    render :json => {:cluster => @cluster, :issues => @issues}
  end
end
