namespace :uploads do
	task :delete => :environment do
		Jam.to_delete.each do |j|
			j.jam_zip_upload.remove!
			j.upload_deleted_at = Time.zone.now
			j.save!
		end
	end
end