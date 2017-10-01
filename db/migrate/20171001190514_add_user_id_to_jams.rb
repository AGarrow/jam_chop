class AddUserIdToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :user_id, :integer
  end
end
