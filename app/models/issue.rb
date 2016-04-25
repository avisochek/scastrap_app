class Issue < ActiveRecord::Base
  has_and_belongs_to_many :cluster
  belongs_to :request_type
  belongs_to :city
  belongs_to :street
  self.primary_key = 'id_'

  def self.bulk_upsert issues
    self.bulk_issue_params(issues)["issues"].each do |issue|
      if Issue.where(id_: issue[:id_]).count>0
        Issue.update(issue[:id_],issue_params).save()
      else
        Issue.create(issue_params).save()
      end
    end
  end

  private
    def self.bulk_issue_params issues
      issues.permit(:issues=>[
        :id_,
        :request_type_id,
        :created_at,
        :status,
        :lng,
        :lat,
        :street_id,
        :city_id,
        :address,
        :summary,
        :description])
    end
end
