class PartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_part, only: [ :destroy ]

  def index
    @parts = Part.order(created_at: :desc)
  end

  def new
    @part = current_user.parts.new
  end

  def create
    @part = current_user.parts.new(part_params)

    if @part.save
      redirect_to parts_path, notice: "Part posted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @part.destroy
    redirect_to parts_path, notice: "Part removed."
  end

  private

  def set_part
    @part = current_user.parts.find(params[:id])
  end

  def part_params
    params.require(:part).permit(:part, :description, :price, :contact_info)
  end
end
