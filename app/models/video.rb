class Video < Yt::Video
	attr_accessor :youtube_url
	
	def initialize(youtube_url)		
		@youtube_url = youtube_url
		super(id: content_id)
	end

	def content_id
		@_content_id ||= Rack::Utils.parse_query(@youtube_url.split("?")[-1])["v"]
	end

	def track_suggestions
		parse_text(description) || default_track_suggestion
	end

	private

		def default_track_suggestion
			[{ start_time: "00:00", name: title, end_time: end_time, track_number: 1 }]
		end

		def end_time
			Time.at(duration).utc.strftime("%H:%M:%S")
		end

		def parse_text(text)
			time_regex = /[\[\(]?(\d{1,2}:\d{1,2}(?::\d{1,2})?)[[\]\)]]?/
			return unless text.scan(time_regex).size > 1
			tracks = text.split("\n").map { |l| l =~ time_regex ? { start_time: l.match(time_regex).captures.first, name: l.gsub(time_regex, '').strip} : nil }.compact
			tracks.each_with_index do |t,i|
				track_end_time = t == tracks.last ? end_time : tracks[i+1][:start_time]
				t[:end_time] = track_end_time
				t[:track_number] = i + 1
			end
			tracks
		end
end
