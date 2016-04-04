class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches, id: false do |t|
      t.integer :id_, null: false
      t.string :created_at
      t.belongs_to :city
      t.timestamps null: false
    end
  end
end
