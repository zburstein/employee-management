class TipsController < ApplicationController
  before_action :authenticate_employee_ajax!

  #grabs employees total tip for the shift
  def show
    #correct_employee?(params[:employee_id])
    correct_employee?(params[:id])
    @employee = current_employee
    #@employee = Employee.find(session[:employee_id])
  end

end
