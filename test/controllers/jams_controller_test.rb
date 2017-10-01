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

    it "should reject invalid youtube urls" do
      get new_jam_path(params: { jam_params: { content_url:"https://not-youtube.com/watch" } })
      assert_response :success
      assert_select ".alert.alert-danger", text: I18n.t('activerecord.errors.models.jam.attributes.youtube_url')
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
            "track_number": "1",
            "start_time": "00:00",
            "end_time": "04:15",
            "name": "Never Forget Your Token"
          },
          "1": {
            "track_number": "2",
            "start_time": "04:15",
            "end_time": "09:56",
            "name": "Creeps Crouchin"
          },
          "2": {
            "track_number": "3",
            "start_time": "09:56",
            "end_time": "15:08",
            "name": "Panic In Funkytown"
          }
        }
      }
    }

    let(:duplicate_tracks) { 
      {
        "youtube_url": "https://www.youtube.com/watch?v=NsdGVPG3ZlQ",
        "youtube_id": "NsdGVPG3ZlQ",
        "cover_image_remote_url": "https://i.ytimg.com/vi/NsdGVPG3ZlQ/mqdefault.jpg",
        "youtube_title": "Blockhead - Interludes After Midnight (Full Album)",
        "artist": "",
        "tracks_attributes": {
          "0": {
            "track_number": "1",
            "start_time": "00:00",
            "end_time": "04:15",
            "name": "Never Forget Your Token"
          },
          "1": {
            "track_number": "2",
            "start_time": "04:15",
            "end_time": "09:56",
            "name": "Never Forget Your Token"
          }
        }
      }
    }

    let(:no_tracks) { 
      {
        "youtube_url": "https://www.youtube.com/watch?v=NsdGVPG3ZlQ",
        "youtube_id": "NsdGVPG3ZlQ",
        "cover_image_remote_url": "https://i.ytimg.com/vi/NsdGVPG3ZlQ/mqdefault.jpg",
        "youtube_title": "Blockhead - Interludes After Midnight (Full Album)",
        "artist": "",
        "tracks_attributes": {
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

    it "should reject albums with dupliate tracks" do
      VCR.use_cassette("controllers/jams/create_duplicate_tracks") do
        ChopJamJob.expects(:perform_later).never
        post jams_path(params: { jam: duplicate_tracks })
        assert_select ".alert.alert-danger", text: I18n.t('activerecord.errors.models.jam.attributes.tracks.unique')
      end
    end

    it "should reject albums with no tracks" do
      VCR.use_cassette("controllers/jams/create_no_tracks") do
        ChopJamJob.expects(:perform_later).never
        post jams_path(params: { jam: no_tracks })
        assert_select(".alert.alert-danger")
      end
    end
  end
end