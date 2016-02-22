class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters, id: false do |t|
      t.integer :id_, null: false
      t.string :rtt
      t.string :request_type_id
      t.integer :score
      t.timestamps null: false
    end
    #add_index :clusters, :id_, unique: true
  end
end
