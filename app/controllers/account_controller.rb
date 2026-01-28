class AccountController < ApplicationController
  before_action :authenticate_user!

  def show
    @rewards = current_user.rewards
  end

  def claim_reward
    code = params[:code].to_s.strip

    if current_user.claim_reward(code)
      redirect_to account_path(reward_claim: "success")
    else
      redirect_to account_path(reward_claim: "invalid")
    end
  end
end
