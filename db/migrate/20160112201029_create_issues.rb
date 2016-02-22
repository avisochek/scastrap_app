class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :id_
      t.integer :repid
      t.integer :request_type_id
      t.string :rtt
      t.string :created_at
      t.boolean :acknowledged
      t.string :status
      t.string :address
      t.float :lng
      t.float :lat
      t.string :neighborhood
      t.string :street_name
      t.string :acknowledged_at
      t.string :closed_at
      t.integer :cluster_id
      t.timestamps null: false
    end
    add_index :issues, :cluster_id
  end
end
