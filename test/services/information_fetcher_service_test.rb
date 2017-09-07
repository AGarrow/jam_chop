require 'test_helper'

class InformationFetcherServiceTest <  ActiveSupport::TestCase
	let(:valid_service) { InformationFetcherService.new('https://www.youtube.com/watch?v=VlQV2kFXDb8&t=1968s')}
	let(:valid_service_no_tracks) { InformationFetcherService.new('https://www.youtube.com/watch?v=dJtYi8BWJZU') }
	describe "track_suggestions" do
		it "should suggest tracks" do
			VCR.use_cassette("services/information_fetcher/valid") do
				suggestions = valid_service.track_suggestions
				assert_equal 17, suggestions.size
				assert_equal({ start_time: "0:54", name: "Shine", end_time: "16:10", track_number: 1 }, suggestions.first)
				assert_equal({ start_time: "02:37:14", name: "This Must Be the Place (Naive Melody)", end_time: "02:45:48", track_number: 17}, suggestions.last)
			end
		end

		it "should suggest one track of the duration of the video if none are found" do
			VCR.use_cassette("services/information_fetcher/valid_no_track_times") do
				suggestions = valid_service_no_tracks.track_suggestions
				assert_equal 1, suggestions.size
				assert_equal({ start_time: "00:00", name: "String Cheese Incident - Electric Forest Festival - 2011-07-02", end_time: "02:33:03", track_number: 1 }, suggestions.first)
			end
		end
	end

	describe "content_id" do
		it "should return the correct content_id" do
			VCR.use_cassette("services/information_fetcher/valid") do
				assert_equal "VlQV2kFXDb8", valid_service.content_id 
			end			
		end
	end

	describe "initialize" do
		it "should return nil for an invalid url" do
			assert_raises InvalidURLError do
				InformationFetcherService.new('https://www.youtube.com/watch?ddfdfdfd')
			end
		end
	end

	describe "video_title" do
		it "should return the video title" do
			VCR.use_cassette("services/information_fetcher/valid_title") do
				assert_equal "String Cheese Incident - 03/18/16 - Brooklyn Bowl - COMPLETE", valid_service.video_title
			end
		end
	end
end