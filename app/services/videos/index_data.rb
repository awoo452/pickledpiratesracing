module Videos
  class IndexData
    Result = Struct.new(:videos, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(videos: Video.all)
    end
  end
end
