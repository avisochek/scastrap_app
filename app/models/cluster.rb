class Cluster < ActiveRecord::Base
  has_and_belongs_to_many :issues#, {:primary_key=>'id_'}
  belongs_to :request_type#, {:foreign_key=>'request_type_id'}
  belongs_to :batch
  self.primary_key = 'id_'
end
