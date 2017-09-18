require "mp3info"
module Metadata
	module Mp3
		class << self
			def apply(jam)
				jam.tracks.each do |t|
					Rails.logger.debug(t.track_path)
					Mp3Info.open(t.track_path) do |f|
						f.tag.tracknum = t.track_number
						f.tag.title = t.name
						f.tag.album = jam.youtube_title
						f.tag.artist = jam.artist
						f.tag2.add_picture(Paperclip.io_adapters.for(jam.cover_image).read)					
					end
				end
			end
		end
	end
end