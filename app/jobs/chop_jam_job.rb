class ChopJamJob < ActiveJob::Base
	class << self
		def download(jam)
			system "youtube-dl -o #{jam.youtube_dl_path} -x --audio-format 'wav' \"https://www.youtube.com/watch?v=2IRcM9qwDwo\""
		end

		def chop(jam)
			return unless jam.tracks.any?
			jam.tracks.each do |track|
				system "ffmpeg -i #{jam.raw_audio_path} -ss #{track.start_time} -to #{track.end_time} -c copy \"#{jam.download_dir_path}/#{track.track_number} #{track.name}.wav\""
			end
			FileUtils.rm(jam.raw_audio_path)
		end

		def tar(jam)
			system "tar -zxvfar #{jam.youtube_title}.tar.gz #{jam.download_dir_path}"
		end
	end
end