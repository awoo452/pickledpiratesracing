class AccountController < ApplicationController
  before_action :authenticate_user!

  def show
    @rewards = current_user.rewards
    @parts = current_user.parts.order(created_at: :desc)
  end

  def edit_details
  end

  def claim_reward
    code = params[:code].to_s.strip

    if current_user.claim_reward(code)
      redirect_to account_path(reward_claim: "success")
    else
      redirect_to account_path(reward_claim: "invalid")
    end
  end

  def update_details
    if current_user.update(user_details_params)
      current_user.grant_profile_completed_reward
      redirect_to account_path
    else
      redirect_to edit_account_details_path
    end
  end

  private

  def user_details_params
    params.fetch(:user, {}).permit(:first_name, :last_name)
  end
end
