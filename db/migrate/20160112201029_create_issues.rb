class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues, id: false do |t|
      t.integer :id_, null: false
      t.belongs_to :request_type, index: true
      t.belongs_to :city, index: true
      t.belongs_to :street, index: true
      t.string :created_at
      t.string :status
      t.string :address
      t.string :description
      t.string :summary
      t.float :lng
      t.float :lat
    end
  end
end
