require 'test_helper'

class JamsControllerTest < ActionDispatch::IntegrationTest
  describe "#new" do
    it "should respond with the form url if no youtube url is provided" do
      get new_jam_path
      assert_response :success
      assert_select "input[name='jam[youtube_title]']"
    end

    it "present the jam info and track suggestions if youtube url with track list is provided" do
      VCR.use_cassette("controllers/jams/new_valid_with_tracks") do
        get new_jam_path(params: { jam_params: { content_url: "https://www.youtube.com/watch?v=VlQV2kFXDb8&t=1968s" } })
        assert_response :success
        assert_select "input[value='String Cheese Incident - 03/18/16 - Brooklyn Bowl - COMPLETE']"
        assert_select "input[name='jam[tracks_attributes][0][track_number]']"
        assert_select "input[name='jam[tracks_attributes][16][track_number]']"
      end
    end
  end
end
