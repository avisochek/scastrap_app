class City < ActiveRecord::Base
  has_many :issues
  has_many :clusters
  has_many :clusters_issues
  has_many :request_types
  has_many :streets
  has_many :batches
  self.primary_key = 'id_'
end
