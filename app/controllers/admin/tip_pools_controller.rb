class Admin::TipPoolsController < ApplicationController
  before_action :authenticate_manager

  def show
    @sale = Sale.find(params[:id])
    @tip_pools = @sale.tip_pools
  end
end
