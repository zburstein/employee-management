class Admin::PositionsController < ApplicationController
  before_action :authenticate_manager

  def index
    @positions = Position.all
  end

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    if @position.save
      flash[:success] = "Position successfully saved"
      redirect_to admin_positions_path
    else
      flash.now[:danger] = "Position was not created"
      render "new"
    end

  end

  def edit
    @position = Position.find(params[:id])
  end

  def update
    @position = Position.find(params[:id])
    if @position.update_attributes(position_params)
      flash[:success] = "Successfully updated the #{@position.name} position"
      redirect_to admin_positions_path
    else
      flash.now[:danger] = "Failed to update position"
      render "edit"
    end
  end

  private
  def position_params
    params.require(:position).permit(:name, :starting_wage, :solo_associated_tip_percentage, :multi_associated_tip_percentage, :location, :associate_with_tip)
  end
end
