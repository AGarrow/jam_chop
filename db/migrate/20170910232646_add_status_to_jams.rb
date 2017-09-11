class AddStatusToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :status, :integer
  end
end
