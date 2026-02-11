module VideosHelper
  def youtube_embed(video)
    if video.youtube_id.present?
      url = "https://www.youtube.com/embed/#{video.youtube_id}"
      return url if video.start_seconds.blank?

      "#{url}?start=#{video.start_seconds}"
    elsif video.youtube_playlist_id.present?
      "https://www.youtube.com/embed/videoseries?list=#{video.youtube_playlist_id}"
    end
  end
end
