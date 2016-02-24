class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues, id: false do |t|
      t.integer :id_, null: false
      t.integer :request_type_id
      t.string :created_at
      t.string :status
      t.float :lng
      t.float :lat
      t.string :street_name
      t.timestamps null: false
    end
  end
end
