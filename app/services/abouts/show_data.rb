module Abouts
  class ShowData
    Result = Struct.new(:about, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(about: About.first)
    end
  end
end
