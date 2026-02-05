module Events
  class IndexData
    Result = Struct.new(:events, keyword_init: true)

    def self.call
      new.call
    end

    def call
      Result.new(events: Event.order(event_date: :asc))
    end
  end
end
