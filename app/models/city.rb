class City < ActiveRecord::Base
  has_many :issues
  has_many :clusters
  has_many :request_types
  has_many :streets
  self.primary_key = 'id_'
end
