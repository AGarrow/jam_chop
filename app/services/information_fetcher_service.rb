class InformationFetcherService
	attr_accessor :video
	
	def initialize(content_id)
		@video = Yt::Video.new id: content_id
	end

	def track_suggestions
		parse_text(video.description)
	end

	private

		def parse_text(text)
			time_regex = /(\d{1,2}:\d{1,2}(?::\d{1,2})?)/
			return unless text.scan(time_regex).size > 1
			tracks = text.split("\n").map { |l| l =~ time_regex ? Track.new(start_time: l.match(time_regex).to_s, name: l.gsub(time_regex, '').strip) : nil }.compact
			tracks.each_with_index do |t,i|
				track_end_time = t == tracks.last ? end_time : tracks[i+1].start_time
				t.end_time = track_end_time
				t.track_number = i + 1
			end
			tracks
		end

		def end_time
			Time.at(video.duration).utc.strftime("%H:%M:%S")
		end
end