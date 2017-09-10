class JamsController < ApplicationController

  def index
    render locals: { jams: Jam.all }
  end

  def show
    render locals: { jam: jam }
  end

  def new
    render locals: { jam: Jam.new() } and return unless youtube_url 
    jam = Jam.new(
      youtube_url: youtube_url,
      youtube_id: video.content_id,
      youtube_title: video.title,
      )
    jam.cover_image_remote_url = video.thumbnail_url(size = :medium)
    video.track_suggestions.each { |t| jam.tracks.build(t) }
    render locals: {
      jam: jam || Jam.new(youtube_url),
    }
  end

  def edit
  end

  def create
    jam = Jam.new(jam_params)
    jam.cover_image_remote_url = jam_params[:cover_image_remote_url]

    respond_to do |format|
      if jam.save
        format.html { redirect_to jam, notice: 'Jam was successfully created.' }
        format.json { render :show, status: :created, location: jam }
      else
        format.html { render :new }
        format.json { render json: jam.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @jam.update(jam_params)
        format.html { redirect_to @jam, notice: 'Jam was successfully updated.' }
        format.json { render :show, status: :ok, location: @jam }
      else
        format.html { render :edit }
        format.json { render json: @jam.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @jam.destroy
    respond_to do |format|
      format.html { redirect_to jams_url, notice: 'Jam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def fetch_info

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def jam
      @jam ||= Jam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jam_params
      params.require(:jam).permit(:cover_image_remote_url, :youtube_url, :youtube_title, :youtube_id, tracks_attributes: [:track_number, :start_time, :name, :end_time])
    end

    def youtube_url
      params[:jam_params]&.[](:content_url)
    end

    def video
      @_video ||= Video.new(youtube_url)
    end
end
