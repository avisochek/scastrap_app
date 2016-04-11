class IssuesController < ApplicationController
  def get_issues
    @issues = Issue.where(:request_type_id=>params[:request_type_id]).pluck(:lng,:lat)
    if @issues
      render :response =>200, :json=> {:issues=>@issues}
    else
      render :response =>404
    end
  end
  def get_cluster
    @issues = Cluster.find(params[:cluster_id]).issues
    if @issues
      render :response =>200, :json=> {:issues=>@issues}
    else
      render :response =>404
    end
  end
end
