class EmployeesController < ApplicationController
  before_action :authenticate_employee!

  def dashboard
    @employee = current_employee
    @sale = Sale.new
  end

end
