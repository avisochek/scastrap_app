class Issue < ActiveRecord::Base
  has_and_belongs_to_many :cluster
  belongs_to :request_type
  belongs_to :city
  belongs_to :street
  self.primary_key = 'id_'

  def self.bulk_upsert issues
    issues.each do |issue|
      if Issue.where(id_: issue[:id_]).count>0
        Issue.update(issue[:id_],issue).save()
      else
        Issue.create(issue).save()
      end
    end
  end
end
