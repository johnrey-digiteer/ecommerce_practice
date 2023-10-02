class RemoveTypeFromVariants < ActiveRecord::Migration[7.0]
  def change
    remove_column :variants, :type
  end
end
