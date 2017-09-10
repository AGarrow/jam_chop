class ChopJamJob < ActiveJob::Base
	queue_as :default

	def perform(jam)
		download(jam)
		chop(jam)
		tar(jam)
		upload(jam)
		cleanup(jam)
	end

	private

		def chop(jam)
			return unless jam.tracks.any?
			jam.tracks.each do |track|
				system "ffmpeg -i #{jam.raw_audio_path} -ss #{track.start_time} -to #{track.end_time} -c copy \"#{track.track_path}\""
			end
			FileUtils.rm(jam.raw_audio_path)
		end

		def cleanup(jam)
			jam.update_attributes(uploaded_at: Time.zone.now, upload_deleted_at: nil)
			FileUtils.rm_rf(jam.download_root_path)
		end

		def download(jam)
			system "youtube-dl -o #{jam.youtube_dl_path} -x --audio-format 'wav' \"#{jam.youtube_url}\""
		end

		def tar(jam)
			system "tar -zcvf #{jam.tar_path} #{jam.download_dir_path}"
			FileUtils.rm_rf(jam.download_dir_path)
		end

		def upload(jam)
			File.open(jam.tar_path) { |f| jam.jam_zip_upload = f }
			jam.save!
		end
	end