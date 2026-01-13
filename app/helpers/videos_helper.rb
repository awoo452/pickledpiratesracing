module VideosHelper
  def youtube_embed(video)
    if video.youtube_playlist_id.present?
      "https://www.youtube.com/embed/videoseries?list=#{video.youtube_playlist_id}"
    else
      "https://www.youtube.com/embed/#{video.youtube_id}"
    end
  end
end