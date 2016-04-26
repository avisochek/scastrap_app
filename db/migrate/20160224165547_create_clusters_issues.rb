class CreateClustersIssues < ActiveRecord::Migration
  def change
    create_table :clusters_issues do |t|
      t.belongs_to :cluster
      t.belongs_to :issue
      t.belongs_to :batch
      t.belongs_to :city
    end
  end
end
