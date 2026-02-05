class AccountController < ApplicationController
  before_action :authenticate_user!

  def show
    data = Account::ShowData.call(user: current_user)
    @rewards = data.rewards
    @parts = data.parts
  end

  def edit_details
  end

  def claim_reward
    result = Account::ClaimReward.call(user: current_user, code: params[:code])
    if result.success?
      redirect_to account_path(reward_claim: "success")
    else
      redirect_to account_path(reward_claim: "invalid")
    end
  end

  def update_details
    result = Account::UpdateDetails.call(user: current_user, params: user_details_params)
    if result.success?
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
