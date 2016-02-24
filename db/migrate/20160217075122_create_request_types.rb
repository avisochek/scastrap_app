class CreateRequestTypes < ActiveRecord::Migration
  def change
    create_table :request_types, id: false do |t|
      t.integer :id_, null: false
      t.string :name
      t.timestamps null: false
    end
  end
end
