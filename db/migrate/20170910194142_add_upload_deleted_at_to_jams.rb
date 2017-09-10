class AddUploadDeletedAtToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :upload_deleted_at, :datetime
  end
end
