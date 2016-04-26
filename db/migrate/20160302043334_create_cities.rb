class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities, id: false do |t|
      t.integer :id_, null: false
      t.float :lat
      t.float :lng
      t.string :name
    end
  end
end
