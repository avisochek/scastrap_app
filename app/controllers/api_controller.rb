class ApiController < ApplicationController
  Key=ENV['API_KEY']
  before_action :correct_key?
  skip_before_action :verify_authenticity_token

  ## create city
  def create_city
    if City.where(:id_=> city_params[:id_]).count == 0
      if City.new(city_params).save()
        render json: {message: "success!"}
      else
        render json: {message: "could not create resource"}
      end
    else
      render json: {message: "could not create resource"}
    end
  end

  ## request_type
  def create_request_type
    if RequestType.where(:id_=> request_type_params[:id_]).count == 0
      if RequestType.new(request_type_params).save()
        render json: {message: "success!"}
      else
        render json: {message: "could not create resource"}
      end
    else
      render json: {message: "could not create resource"}
    end
  end

  ## create batch
  def create_batch
    if Batch.where(:id_=> batch_params[:id_]).count == 0
      puts "new batch"
      Batch.delay.new(batch_params).save
      Batch.delay.drop_old batch_params
      render json: {message: "success!"}
    else
      puts "no new batch"
      Batch.drop_old batch_params
      render json: {message: "could not create resource"}
    end
  end

  ## create street
  def bulk_upsert_street
    if Street.delay.bulk_upsert(bulk_street_params[:streets])
      render status: 200, json: {message: "success!"}
    else
      render status: 403, json: {message: "could not create resource"}
    end
  end

  ## create issue
  def bulk_upsert_issue
    if Issue.delay.bulk_upsert(bulk_issue_params[:issues])
      render status: 200, json: {message: "success!"}
    else
      render status: 403, json: {message: "could not create resource"}
    end
  end

  ## create cluster
  def bulk_upsert_cluster
    if Cluster.delay.bulk_upsert(bulk_cluster_params[:clusters])
      render status: 200, json: {message: "success!"}
    else
      render status: 403, json: {message: "could not create resource"}
    end
  end

  ## cluster_issue
  def bulk_upsert_cluster_issue
    if ClustersIssues.delay.bulk_upsert(bulk_cluster_issue_params[:clusters_issues])
      render status: 200, json: {message: "success!"}
    else
      render status: 403, json: {message: "could not create resource"}
    end
  end

  private
    def bulk_street_params
      params.permit(:streets=>[:id_,
                              :city_id,
                              :name,
                              :length])
    end

    def request_type_params
      params.require(:request_type).permit(:id_,:name,:city_id)
    end

    def batch_params
      params.require(:batch).permit(:id_,:created_at,:city_id)
    end

    def city_params
      params.require(:city).permit(:id_,:name,:lat,:lng)
    end

    def bulk_issue_params
      params.permit(:issues=>[:id_,
                      :request_type_id,
                      :created_at,
                      :status,
                      :lng,
                      :lat,
                      :street_id,
                      :city_id,
                      :address,
                      :summary,
                      :description])
    end

    def bulk_cluster_issue_params
      params.permit(:clusters_issues=>[:cluster_id,:issue_id])
    end

    def bulk_cluster_params
      params.permit(:clusters=>[:id_,
                    :request_type_id,
                    :score,
                    :city_id,
                    :batch_id,
                    :lng,
                    :lat])
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
