class Cluster < ActiveRecord::Base
  has_and_belongs_to_many :issues
  belongs_to :request_type
  belongs_to :city
  belongs_to :batch
  self.primary_key = 'id_'
end
