class Issue < ActiveRecord::Base
  has_and_belongs_to_many :cluster
  belongs_to :request_type
  belongs_to :city
  belongs_to :street
  self.primary_key = 'id_'
end
