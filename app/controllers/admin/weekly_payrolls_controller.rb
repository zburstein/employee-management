class Admin::WeeklyPayrollsController < ApplicationController
  before_action :authenticate_manager

  def show
    @weekly_payroll = WeeklyPayroll.find(params[:id])
    @shifts = @weekly_payroll.shifts.order("created_at DESC")

    week = @weekly_payroll.week
  end

  def create
    #get the employee and the week
    @employee = Employee.find(params[:employee])
    @week = Week.find(params[:week])

    @weekly_payroll = WeeklyPayroll.new(employee: @employee, week: @week)

    if @weekly_payroll.save
      @alert = {type: "success", message: "Payroll succesfully created"}
    else
      @alert = {type: "danger", message: "Payroll did not save. Employee already has one for this week"}
    end

  end
end
