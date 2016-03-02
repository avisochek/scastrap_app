class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters, id: false do |t|
      t.integer :id_, null: false
      t.belongs_to :request_type, index: true
      t.belongs_to :city, index: true
      t.integer :score
      t.belongs_to :batch, index: true
      t.timestamps null: false
    end
    #add_index :clusters, :id_, unique: true
  end
end
