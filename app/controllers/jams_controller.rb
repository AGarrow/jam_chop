class JamsController < ApplicationController

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
    render locals: { jam: jam || Jam.new(youtube_url) }
  end

  def create
    jam = Jam.new(jam_params)
    jam.cover_image_remote_url = jam_params[:cover_image_remote_url]
    if jam.save
      ChopJamJob.perform_later(jam)
      redirect_to jam
    else
      render :new, locals: { jam: jam }
    end
  rescue ActiveRecord::RecordNotUnique
    jam.errors.add(:tracks, :unique)
    jam.tracks.group_by(&:name).select { |k,v| v.length > 1 }.each_value { |v| v.each { |t| t.errors.add(:name, :unique) } } 
    render :new, locals: { jam: jam }    
  end

  private

    def jam
      @_jam ||= Jam.find(params[:id])
    end

    def jam_params
      params.require(:jam).permit(:cover_image_remote_url, :youtube_url, :youtube_title, :youtube_id, tracks_attributes: [:track_number, :start_time, :name, :end_time, :download])
    end

    def youtube_url
      params[:jam_params]&.[](:content_url)
    end

    def video
      @_video ||= Video.new(youtube_url)
    end
end
