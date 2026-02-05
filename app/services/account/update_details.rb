module Account
  class UpdateDetails
    Result = Struct.new(:success?, keyword_init: true)

    def self.call(user:, params:)
      new(user: user, params: params).call
    end

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      if @user.update(@params)
        @user.grant_profile_completed_reward
        Result.new(success?: true)
      else
        Result.new(success?: false)
      end
    end
  end
end
