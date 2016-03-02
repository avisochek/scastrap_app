class City < ActiveRecord::Base
  has_many :issues
  has_many :clusters
  has_many :request_types
  self.primary_key = 'id_'
end
