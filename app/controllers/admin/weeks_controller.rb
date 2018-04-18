class Admin::WeeksController < ApplicationController
  before_action :authenticate_manager

  def show
    #get the week and the payrolls
    @week = Week.find(params[:id])
    @employees = Employee.all
    if !params[:employee_id].nil? && !params[:employee_id].empty?
      @employee = @employees.find(params[:employee_id])
      @weekly_payrolls = @week.weekly_payrolls.where(employee: @employee.id)
    else
      @weekly_payrolls = @week.weekly_payrolls
    end

    #and the list of employees without a payroll in the week
    @employees_without_payroll = @week.employees_without_payroll
    
    respond_to do |format|
      format.html {@weeks = Week.all.order('date_started DESC')}
      format.js
    end
  end
end
