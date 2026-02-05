module Parts
  class IndexData
    Result = Struct.new(:parts, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(parts: Part.order(created_at: :desc))
    end
  end
end
