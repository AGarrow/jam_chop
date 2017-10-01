require 'test_helper'

class AlbumCreationTest < JamChop::IntegrationTest
	let(:jam) { Jam.find_by(id: 42) }

	describe "album creation" do
		it "should successfully create an album" do
			VCR.use_cassette("integration/album_creation") do
				visit new_jam_path
				page.assert_selector "#jam_params_content_url"
				page.find("#jam_params_content_url").set(jam.youtube_url)
				click_button "Go"
				page.assert_selector "input[value='Look at this graph']"
				page.assert_selector "[name='jam[artist]']"
				page.assert_selector "tr", count: 1
				ChopJamJob.expects(:perform_later).returns(true)
				click_button I18n.t('components.album.create')
				JamUploader.any_instance.stubs(:url).returns("https://some-upload-url.com")
				visit jam_path(id: Jam.last.id)
				page.assert_selector "a.btn", text: I18n.t('components.album.download')
			end
		end
	end
end