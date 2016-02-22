class RequestType < ActiveRecord::Base
  has_many :clusters, {:primary_key => 'id_'}
  has_many :issues, {:primary_key => 'id_'}
  self.primary_key = 'id_'
end
