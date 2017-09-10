namespace :uploads do
	task :delete => :environment do
		Jam.to_delete.each do |j|
			jam.jam_zip_upload.remove!
			jam.upload_deleted_at = Time.zone.now
			jam.save!
		end
	end
end