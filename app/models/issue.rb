class Issue < ActiveRecord::Base
  has_and_belongs_to_many :cluster#, {:foreign_key=>'cluster_id'}
  belongs_to :request_type#, {:foreign_key=>'request_type_id'}
  belongs_to :city
  self.primary_key = 'id_'
end
