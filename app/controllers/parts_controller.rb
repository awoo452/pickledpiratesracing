class PartsController < ApplicationController
  before_action :authenticate_user!

  def index
    data = Parts::IndexData.call
    @parts = data.parts
  end

  def new
    @part = current_user.parts.new
  end

  def create
    result = Parts::CreatePart.call(user: current_user, params: part_params)
    @part = result.part

    if result.success?
      redirect_to parts_path, notice: "Part posted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    result = Parts::DestroyPart.call(user: current_user, id: params[:id])
    if result.success?
      redirect_to parts_path, notice: "Part removed."
    else
      redirect_to parts_path, alert: "Not authorized to delete that post."
    end
  end

  private

  def part_params
    params.require(:part).permit(:part, :description, :price, :contact_info, :era, :disclaimer_ack)
  end
end
