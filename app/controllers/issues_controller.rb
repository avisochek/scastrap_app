class IssuesController < ApplicationController
  def get_issues
    @issues = Issue.where(:request_type_id=>params[:request_type_id]).pluck(:lng,:lat)
    render :response =>200, :json=> {:issues=>@issues}
  end
  def get_cluster
    @issues = Cluster.find(params[:cluster_id]).issues
    render :response =>200, :json=> {:issues=>@issues}
  end
end
