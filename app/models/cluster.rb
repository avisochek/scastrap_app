class Cluster < ActiveRecord::Base
  has_and_belongs_to_many :issues
  belongs_to :request_type
  belongs_to :city
  belongs_to :batch
  self.primary_key = 'id_'

  def self.bulk_upsert clusters
    clusters.each do |cluster|
      if Cluster.where(:id_=>cluster[:id_]).count==0
        Cluster.create(cluster).save()
      end
    end
  end
end
