module Account
  class ClaimReward
    Result = Struct.new(:success?, keyword_init: true)

    def self.call(user:, code:)
      new(user: user, code: code).call
    end

    def initialize(user:, code:)
      @user = user
      @code = code.to_s.strip
    end

    def call
      Result.new(success?: @user.claim_reward(@code))
    end
  end
end
