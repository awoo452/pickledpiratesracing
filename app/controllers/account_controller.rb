class AccountController < ApplicationController
  before_action :authenticate_user!

  def show
    @rewards = current_user.rewards
  end
end
