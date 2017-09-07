class InvalidURLError < StandardError ; end
class InformationFetcherService
	attr_accessor :video, :youtube_url
	
	def initialize(youtube_url)
		@youtube_url = youtube_url
		raise InvalidURLError unless content_id
		@video = Yt::Video.new id: content_id
	end

	def content_id
		youtube_url.match(/v=(\w*)/).captures.first if /v=(\w*)/ =~ youtube_url
	end

	def video_title
		video.title
	end

	def track_suggestions
		parse_text(video.description) || default_track_suggestion
	end

	private

		def default_track_suggestion
			[{ start_time: "00:00", name: video_title, end_time: end_time, track_number: 1 }]
		end

		def parse_text(text)
			time_regex = /\[?(\d{1,2}:\d{1,2}(?::\d{1,2})?)\]?/
			return unless text.scan(time_regex).size > 1
			tracks = text.split("\n").map { |l| l =~ time_regex ? { start_time: l.match(time_regex).captures.first, name: l.gsub(time_regex, '').strip} : nil }.compact
			tracks.each_with_index do |t,i|
				track_end_time = t == tracks.last ? end_time : tracks[i+1][:start_time]
				t[:end_time] = track_end_time
				t[:track_number] = i + 1
			end
			tracks
		end

		def end_time
			Time.at(video.duration).utc.strftime("%H:%M:%S")
		end
end