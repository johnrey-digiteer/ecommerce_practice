class AddTypeToVariants < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :type, :integer
  end
end
