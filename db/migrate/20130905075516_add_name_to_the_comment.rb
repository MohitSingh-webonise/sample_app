class AddNameToTheComment < ActiveRecord::Migration
  def change
    add_column :comments, :name, :string
  end
end
