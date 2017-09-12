class ChopJamJob < ActiveJob::Base
	queue_as :default

	def perform(jam)
		update_status(jam, status: :downloading)
		download(jam)
		
		update_status(jam, status: :chopping)
		chop(jam)

		update_status(jam, status: :converting)
		convert(jam)

		update_status(jam, status: :applying_metadata)
		apply_metadata(jam)

		update_status(jam, status: :compressing)
		tar(jam)
		
		update_status(jam, status: :uploading)
		upload(jam)
		
		update_status(jam, status: :cleaning_up)
		cleanup(jam)
		
		update_status(jam, status: :done)
	end

	private

		def apply_metadata(jam)
			"Metadata::#{jam.audio_format.camelize}".constantize.apply(jam)
		end

		def chop(jam)
			return unless jam.tracks.any?
			jam.tracks.each { |track| system "ffmpeg -i #{jam.raw_audio_path} -ss #{track.start_time} -to #{track.end_time} -c copy \"#{track.track_path(audio_format: :wav)}\"" }
			FileUtils.rm(jam.raw_audio_path)
		end

		def cleanup(jam)
			jam.update_attributes(uploaded_at: Time.zone.now, upload_deleted_at: nil)
			FileUtils.rm_rf(jam.download_root_path)
		end

		def convert(jam)
			jam.tracks.each do |t| 
				system "ffmpeg -i #{t.track_path(audio_format: :wav)} -codec:a libmp3lame -qscale:a 0 #{t.track_path}"
				FileUtils.rm(t.track_path(audio_format: :wav))
			end
		end

		def download(jam)
			system "youtube-dl -o #{jam.youtube_dl_path} -x --audio-format 'wav' \"#{jam.youtube_url}\""
		end

		def tar(jam)
			system "tar -zcvf #{jam.tar_path}  -C #{jam.download_dir_path} ."
			FileUtils.rm_rf(jam.download_dir_path)
		end

		def update_status(jam, status:)
			stream = "status_#{jam.id}"
			jam.update_attributes(status: Jam.statuses[status])
			ActionCable.server.broadcast(stream, status: status, download_url: jam.jam_zip_upload.url )
		end

		def upload(jam)
			File.open(jam.tar_path) { |f| jam.jam_zip_upload = f }
			jam.save!
		end
end