require 'test_helper'

class ChopJamJobTest < ActiveJob::TestCase
	let(:valid_jam) { jams(:nickelback) }
	let(:track_1) { tracks(:nickelback_one) }
	let(:track_2) { tracks(:nickelback_two) }

	describe "perform" do
		before do
			valid_jam.cover_image = sample_cover
			valid_jam.save
		end
		it "downloads, converts, and uploads the jam" do
			VCR.use_cassette("jobs/chop_jam/success") do
				track_1 and track_2
				ChopJamJob.perform_now(valid_jam)
				assert valid_jam.jam_zip_upload_url
			end
		end
	end
end