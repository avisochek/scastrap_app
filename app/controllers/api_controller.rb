class ApiController < ApplicationController
  Key="xxxx"
  before_action :correct_key?

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
      render status: 403, json: {message: "could not update resource"}
    end
  end

  def create_issue
    if Issue.new(issue_params).save()
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create issue"}
    end
  end

  def cluster_exists?
    if Cluster.where(:id_=> params[:id_]).length == 0
      render status: 200, json: {message: "false"}
    else
      render status: 200, json: {message: "true"}
    end
  end

  ## for now, we assume
  ## that one a cluster is uploaded,
  ## it does not change
  ## so update_cluster is not necessary
  # def update_cluster
  # end

  def create_cluster
    if Cluster.new(issue_params)
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create cluster"}
    end
  end

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
    if RequestType.new(issue_params)
      render status: 201, json: {message: "sucess!"}
    else
      render status: 403, json: {message: "could not create request type"}
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
                      :street_name,
                      :cluster_id)
      #params[:issue]
    end

    def cluster_params
      params.require(:cluster).permit(:id_,:rtt,
                                  :request_type_id,
                                  :score)
    end

    def request_type_params
      params.require(:request_type).permit(:id_,:name)
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
