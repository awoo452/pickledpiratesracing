module Parts
  class DestroyPart
    Result = Struct.new(:success?, :part, keyword_init: true)

    def self.call(user:, id:)
      new(user: user, id: id).call
    end

    def initialize(user:, id:)
      @user = user
      @id = id
    end

    def call
      part = @user.parts.find(@id)
      part.destroy
      Result.new(success?: true, part: part)
    end
  end
end
