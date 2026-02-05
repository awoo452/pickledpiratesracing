module Parts
  class CreatePart
    Result = Struct.new(:success?, :part, keyword_init: true)

    def self.call(user:, params:)
      new(user: user, params: params).call
    end

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      part = @user.parts.new(@params)
      if part.save
        Result.new(success?: true, part: part)
      else
        Result.new(success?: false, part: part)
      end
    end
  end
end
