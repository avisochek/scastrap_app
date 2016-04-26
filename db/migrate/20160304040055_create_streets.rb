class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.integer :id_, null: false
      t.string :name
      t.belongs_to :city, index: true
      t.float :length
    end
  end
end
