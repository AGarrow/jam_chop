class AddUploadedAtToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :uploaded_at, :datetime
  end
end
