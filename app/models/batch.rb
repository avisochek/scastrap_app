class Batch < ActiveRecord::Base
  has_many :clusters
  belongs_to :city
  self.primary_key = 'id_'

  ## delete old batches along with
  ## associated clusters and
  ## cluster_issue relationships
  def self.drop_old batch
    puts batch
    puts "asdf"
    batches_to_drop = Batch.where(
      :city_id=>batch[:city_id]).where().not(
        :id_=>batch[:id_])
    # puts batches_to_drop
    batches_to_drop.each do |batch_to_drop|
      clusters_to_drop = Cluster.where(:batch_id=>batch_to_drop[:id_])
      # puts clusters_to_drop
      clusters_to_drop.each do |cluster|
        ClustersIssues.where(:cluster_id=>cluster[:id_]).all.delete_all
      end
      clusters_to_drop.all.delete_all
    end
    batches_to_drop.all.delete_all
  end

end
