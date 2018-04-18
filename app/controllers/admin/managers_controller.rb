class Admin::ManagersController < ApplicationController
  before_action :authenticate_manager

  def dashboard
    #@back_button = {display: "Main Dashboard", path: employees_dashboard_path}
  end
end
