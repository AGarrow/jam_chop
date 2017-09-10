class AddAttachmentCoverImageToJams < ActiveRecord::Migration[5.1]
  def self.up
    change_table :jams do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :jams, :cover_image
  end
end
