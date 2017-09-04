require 'test_helper'

class InformationFetcherServiceTest <  ActiveSupport::TestCase
	describe "track_suggestions" do
		let(:service) { InformationFetcherService.new('VlQV2kFXDb8')}
		it "should suggest tracks" do
			VCR.use_cassette("services/information_fetcher/tracks") do
				suggestions = service.track_suggestions
				assert_equal 17, suggestions.size
				assert_equal Track.new(start_time: "0:54", name: "Shine", end_time: "16:10", track_number: 1).inspect, suggestions.first.inspect
				assert_equal Track.new(start_time: "02:37:14", name: "This Must Be the Place (Naive Melody)", end_time: "02:45:48", track_number: 17).inspect, suggestions.last.inspect
			end
		end
	end
end