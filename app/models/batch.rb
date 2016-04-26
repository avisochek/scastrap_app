class Batch < ActiveRecord::Base
  has_many :clusters
  has_many :clusters_issues
  belongs_to :city
  self.primary_key = 'id_'

  ## delete old batches along with
  ## associated clusters and
  ## cluster_issue relationships
  def self.drop_old batch
    Batch.where(
      :city_id=>batch[:city_id]).where().not(
        :id_=>batch[:id_]).delete_all
    Cluster.where(
      :city_id=>batch[:city_id]).where().not(
        :batch_id=>batch[:id_]).delete_all
    ClustersIssues.where(
      :city_id=>batch[:city_id]).where().not(
        :batch_id=>batch[:id_]).delete_all
  end

end
