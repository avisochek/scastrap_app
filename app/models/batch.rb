class Batch < ActiveRecord::Base
  has_many :clusters
  belongs_to :city
  self.primary_key = 'id_'

  ## delete old batches along with
  ## associated clusters and
  ## cluster_issue relationships
  def self.drop_old batch
  #  puts batch
    batches_to_drop = Batch.where(
      :city_id=>batch[:city_id]).where().not(
        :id_=>batch[:id_])
    clusters_to_drop = Cluster.where().not(:batch_id=>batch[:id_])
    clusters_to_drop.each do |cluster|
      ClustersIssues.where(:cluster_id=>cluster[:id_]).delete_all
    end
    clusters_to_drop.delete_all
    batches_to_drop.delete_all
  end

end
