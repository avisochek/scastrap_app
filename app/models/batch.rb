class Batch < ActiveRecord::Base
  has_many :clusters
  belongs_to :city
  self.primary_key = 'id_'

  ## delete old batches along with
  ## associated clusters and
  ## cluster_issue relationships
  def drop_old batch
    batches_to_drop = Batch.where(
      :city_id=>batch[:city_id]).where().not(
        :id_=>batch[:id_]).includes(:clusters)
    batches_to_drop.each do |batch|
      clusters_to_drop = batch.clusters
      clusters_to_drop.each do |cluster|
        clusters_issues.where(:cluster_id=>cluster[:id_]).delete_all
      end
      clusters_to_drop.delete_all
    end
    batches_to_drop.delete_all
  end

end
