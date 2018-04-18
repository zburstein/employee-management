class Admin::ShiftsController < ApplicationController
  before_action :authenticate_manager


  def new
    @shift = Shift.new
    #make it so only can be arrived at from weekly payroll page
    @weekly_payroll = WeeklyPayroll.find(params[:weekly_payroll])
    @week = @weekly_payroll.week
    @employee = @weekly_payroll.employee

  end

  def create
    #need to combine the date and times to get date objects. place them in params
    params[:shift][:created_at] = Time.zone.parse(params[:date_worked][:day] + " " + params[:shift][:created_at])
    params[:shift][:finished_at] = Time.zone.parse(params[:date_worked][:day] + " " + params[:shift][:finished_at])
    @shift = Shift.new(new_shift_params)
    #wrap save in rescue to catch exceptions from callbacks that cause rollback
    begin
      #save (associations handled in callbacks) and redirect
      @shift.save!
      flash[:success] = "Shift creation successful"
      redirect_to admin_weekly_payroll_path @shift.weekly_payroll

    rescue Exception => ex 
      #if failed need to assign variables to render new
      flash.now[:danger] = "Shift creation failed"
      @weekly_payroll = @shift.weekly_payroll
      @week = @weekly_payroll.week
      @employee = @weekly_payroll.employee
      render "new"
    end
  end


  def show
    @shift = Shift.find(params[:id])
    @sales = @shift.sales.order("created_at DESC")
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def update
    #retrieve shift and its weekly payroll
    @shift = Shift.find(params[:id])
    weekly_payroll = @shift.weekly_payroll

    #if completed, then you have to calculate new values for wage and adjust the weekly payroll
    @shift.assign_attributes(shift_update_params)###############

    #wrap save in rescue to catch exceptions from callbacks that cause rollback
    begin
      #save (associations handled in callbacks) and redirect
      @shift.save!
      flash[:success] = "Shift successfully updated"
      redirect_to admin_shift_path @shift

    rescue Exception => ex
      #on failed update, re render
      flash.now[:danger] = "Shift update unsuccessful"
      render  "edit"
    end
  end

  def destroy
    @shift = Shift.find(params[:id]) 
    weekly_payroll = @shift.weekly_payroll

    #wrap destory in rescue to catch exceptions from callbacks
    begin
      #all associated objects detroyed in callbacks. 
      @shift.destroy
      flash[:success] = "Shift successfuly deleted"
      redirect_to admin_weekly_payroll_path(weekly_payroll)

    rescue Exception => ex
      #re render
      flash.now[:danger] = "Shift did not destroy #{ex.message}"
      @sales = @shift.sales.order("created_at DESC")
      render "show"
    end
  end

  private
  def new_shift_params
    params.require(:shift).permit(:position_id, :wage, :created_at, :finished_at, :weekly_payroll_id).
    merge(completed: true, employee: WeeklyPayroll.find(params[:shift][:weekly_payroll_id]).employee)
  end

  def shift_update_params()
    #create array of params to pass to strong params
    params_hash = [:wage, :position_id]
    #ensure that the time was changed before adding it to strong params. For some reason alwasy updates it so need this
    ["created_at", "finished_at"].each do |param_name|
      params_hash << param_name.to_sym if !params[:shift]["#{param_name}(1i)"].nil? && param_to_time(params[:shift], param_name).to_i != @shift[param_name].to_i
    end
    params.require(:shift).permit(params_hash)
  end

  #returns Time object from the values in the created_at and finished_at params. needed to ensure that changed? is correct
  def param_to_time(param_object, param_variable)
    values = []
    #make array of all the shift time values
    (1..6).each do |x|
      values << param_object["#{param_variable}(#{x}i)"]
    end

    #then create and return new date object using taht array
    Time.new(*values)
  end
end
