class Street < ActiveRecord::Base
  has_many :issues
  belongs_to :city
  self.primary_key = :id_
end
