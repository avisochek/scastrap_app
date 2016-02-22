class Issue < ActiveRecord::Base
  belongs_to :cluster, {:foreign_key=>'cluster_id'}
  belongs_to :request_type, {:foreign_key=>'request_type_id'}
  self.primary_key = 'id_'
end
