class ApiController < ApplicationController
  Key="xxxx"
  before_action :correct_key?

  ## street
    def street_exists?
      if Street.where(:id_=> params[:id_]).length == 0
        render status: 200, json: {message: "false"}
      else
        render status: 200, json: {message: "true"}
      end
    end

    def create_street
      if Street.new(street_params).save()
        render status: 201, json: {message: "sucess!"}
      else
        render status: 403, json: {message: "could not create street"}
      end
    end

## city
  def city_exists?
    if City.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  def create_city
    if City.new(city_params).save()
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create city"}
    end
  end

## issue
  def issue_exists?
    if Issue.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  def update_issue
    if Issue.find_by(:id_ => issue_params[:id_]).update(issue_params)
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not update issue"}
    end
  end

  def create_issue
    if Issue.new(issue_params).save()
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create issue"}
    end
  end

## cluster
  def cluster_exists?
    if Cluster.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  def get_latest_cluster_id
    if Cluster.all.length>0
      latest_cluster_id = Cluster.all.order(:id_).last.id_
      render status: 200, json: {latest_cluster_id: latest_cluster_id}
    else
      render status: 200, json: {latest_cluster_id: "none"}
    end
  end

  ## for now, we assume
  ## that one a cluster is uploaded,
  ## it does not change
  ## so update_cluster is not necessary
  # def update_cluster
  # end

  def create_cluster
    if Cluster.new(cluster_params).save
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create cluster"}
    end
  end

## request_type
  def request_type_exists?
    if RequestType.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  ## for now, we assume that one a
  ## request type is uploaded,
  ## it does not change, so
  ## update_request_type is no necessary.
  # def update_request_type
  # end

  def create_request_type
    if RequestType.new(request_type_params).save
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create request type"}
    end
  end

  ## batch
  def batch_exists?
    if Batch.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  def get_latest_batch_id
    if Batch.all.length>0
      latest_batch_id = Batch.all.order(:created_at).last.id_
      render status: 200, json: {latest_batch_id: latest_batch_id}
    else
      render status: 200, json: {latest_batch_id: "none"}
    end
  end

  def create_batch
    if Batch.new(batch_params).save
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create batch"}
    end
  end

## cluster_issue
  def create_cluster_issue
    if ClustersIssues.new(cluster_issue_params).save
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create batch"}
    end
  end


  private
    def issue_params
      params.require(:issue).permit(:id_,
                      :request_type_id,
                      :created_at,
                      :status,
                      :lng,
                      :lat,
                      :street_id,
                      :city_id)
      #params[:issue]
    end

    def street_params
      params.require(:street).permit(:id_,
                                  :city_id,
                                  :name,
                                  :length)
    end

    def cluster_params
      params.require(:cluster).permit(:id_,
                                  :request_type_id,
                                  :score,
                                  :city_id)
    end

    def request_type_params
      params.require(:request_type).permit(:id_,:name,:city_id)
    end

    def batch_params
      params.require(:batch).permit(:id_,:created_at)
    end

    def cluster_issue_params
      params.require(:cluster_issue).permit(:cluster_id,:issue_id)
    end

    def city_params
      params.require(:city).permit(:id_,:name,:lat,:lng)
    end

    ## before fileters
    ## check if API key is correct
    def correct_key?
      if !params[:key]
        render status: 403, json: {message: "authentication failed"}
      elsif !ActiveSupport::SecurityUtils.secure_compare(Key,params[:key])
        render status: 403, json: {message: "authentication failed"}
      end
    end

end
