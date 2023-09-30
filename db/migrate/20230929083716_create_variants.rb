class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.string :name
      t.string :color
      t.integer :size
      t.boolean :required

      t.timestamps
    end
  end
end
