class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities, id: false do |t|
      t.integer :id_, null: false
      t.integer :lat
      t.integer :lng
      t.string :name
      t.timestamps null: false
    end
  end
end
