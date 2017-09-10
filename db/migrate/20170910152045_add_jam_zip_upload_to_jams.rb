class AddJamZipUploadToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :jam_zip_upload, :string
  end
end
