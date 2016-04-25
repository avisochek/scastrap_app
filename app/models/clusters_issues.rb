class ClustersIssues < ActiveRecord::Base
  def self.bulk_upsert clusters_issues
    self.bulk_cluster_issue_params(clusters_issues)["clusters_issues"].each do |cluster_issue|
      if ClustersIssues.where(cluster_issue).count==0
        ClustersIssues.create(cluster_issue).save()
      end
    end
  end
  private
    def self.bulk_cluster_issue_params clusters_issues
      clusters_issues.permit(:clusters_issues=>[:cluster_id,:issue_id])
    end
end
