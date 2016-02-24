class Batch < ActiveRecord::Base
  has_many :clusters
  self.primary_key = 'id_'  
end
