require 'test_helper'

class JamsControllerTest < ActionDispatch::IntegrationTest
  describe "#new" do
    it "should respond with the form url if no youtube url is provided" do
      get new_jam_path
      assert_response :success
      assert_select "input[name='jam_params[content_url]']"
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

  describe "#create" do
    let(:valid_params) { 
      {
        "youtube_url": "https://www.youtube.com/watch?v=NsdGVPG3ZlQ",
        "youtube_id": "NsdGVPG3ZlQ",
        "cover_image_remote_url": "https://i.ytimg.com/vi/NsdGVPG3ZlQ/mqdefault.jpg",
        "youtube_title": "Blockhead - Interludes After Midnight (Full Album)",
        "artist": "",
        "tracks_attributes": {
          "0": {
            "download": "1",
            "track_number": "1",
            "start_time": "00:00",
            "end_time": "04:15",
            "name": "Never Forget Your Token"
          },
          "1": {
            "download": "1",
            "track_number": "2",
            "start_time": "04:15",
            "end_time": "09:56",
            "name": "Creeps Crouchin"
          },
          "2": {
            "download": "1",
            "track_number": "3",
            "start_time": "09:56",
            "end_time": "15:08",
            "name": "Panic In Funkytown"
          }
        }
      }
    }

    it "should create a new jam with valid params" do
      VCR.use_cassette("controllers/jams/create_valid") do
        ChopJamJob.expects(:perform_later).returns(true)
        post jams_path(params: { jam: valid_params } )
        assert_redirected_to jam_path(id: Jam.last.id)
      end
    end
  end
end
