module Account
  class ShowData
    Result = Struct.new(:rewards, :parts, keyword_init: true)

    def self.call(user:)
      new(user: user).call
    end

    def initialize(user:)
      @user = user
    end

    def call
      Result.new(
        rewards: @user.rewards,
        parts: @user.parts.order(created_at: :desc)
      )
    end
  end
end
