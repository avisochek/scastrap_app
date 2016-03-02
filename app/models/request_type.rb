class RequestType < ActiveRecord::Base
  has_many :clusters
  has_many :issues
  belongs_to :city
  self.primary_key = 'id_'
end
