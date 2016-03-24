class ClustersController < ApplicationController
  def home
  end
  def city_menu
    @cities=City.where.not :id_ =>0
    render :json => {:cities => @cities}
  end
  def request_type_menu
    @request_types=RequestType.where(:city_id=>params[:city_id])
    @city=City.find(params[:city_id])
    render :json => {:request_types => @request_types,:city => @city}
  end
  def cluster_menu
    clusters_w_issues=[]
    ## use eager loading to speed up iteration
    clusters = Cluster.includes(:issues=>[:street]).where(:request_type_id=>params[:request_type_id]).includes(:issues).order(score: :desc)
    #issues = Issue.where(:request_type_id=>params[:request_type_id],:status=>["Open","Acknowledged"])
    clusters.each do |cluster|
      ## include street names in cluster array
      cluster_modified = cluster.as_json
      street_names=[]
      cluster_modified[:issues] = cluster.issues
      clusters_w_issues.append(cluster_modified)
    end
    render :json => {:clusters => clusters_w_issues}
  end
  def show_cluster
    @cluster=Cluster.find(params[:cluster_id])
    @issues=Cluster.find(params[:cluster_id]).issues
    render :json => {:cluster => @cluster, :issues => @issues}
  end
end
