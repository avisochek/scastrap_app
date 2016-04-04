class Batch < ActiveRecord::Base
  has_many :clusters
  belongs_to :city
  self.primary_key = 'id_'
end
