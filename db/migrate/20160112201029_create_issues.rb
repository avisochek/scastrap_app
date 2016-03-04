class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues, id: false do |t|
      t.integer :id_, null: false
      t.belongs_to :request_type, index: true
      t.belongs_to :city, index: true
      t.belongs_to :street, index: true
      t.string :created_at
      t.string :status
      t.float :lng
      t.float :lat
      t.timestamps null: false
    end
  end
end
