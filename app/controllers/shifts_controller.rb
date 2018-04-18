class ShiftsController < ApplicationController
  before_action :authenticate_employee_ajax!

  #clock in
  def create
    @employee = current_employee

    #if no active shift, then can clock in
    if(!@employee.current_shift)
      
      @shift = Shift.new(employee: @employee)

      #give proper alert base on save result
      @alert = @shift.save ? {type: "success", message: "You have clocked in at #{@shift.created_at.ctime}"} : {type: "danger", message: "Clock-in failed"}
    else
      #dont create shift cause open one already exists
      @alert = {type: "danger", message: "You are already clocked in"}
    end
  end

  #clock-out
  def clock_out
    @employee = current_employee

    # if clocked in
    if @shift = @employee.current_shift

      #hadnle potential exceptions
      begin
        #clock out 
        @shift.clock_out!
        @alert = {type: "success", message: "You have successfully clocked out at #{@shift.finished_at.ctime}"}

      #rescue potential exceptions from clock_out after callbacks
      rescue Exception => ex
        @alert = {type: "danger", message: "Save of weekly payroll or shift failed: #{ex.message}"}
      end

    #not clocked in 
    else
      @alert = {type: "danger", message: "You are not clocked in"}
    end
  end


end
