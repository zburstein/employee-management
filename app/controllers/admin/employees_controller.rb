class Admin::EmployeesController < ApplicationController
  before_action :authenticate_manager
  before_action :verify_manager_password, only: [:update]

  def index
    @employees = Employee.all.order('id ASC')

  end

  def show
    #retrieves shifts, payrolls, and employee details
    @employee = Employee.find(params[:id])
    params[:time] = -7 if params[:time].nil?
    start = Time.zone.now.advance(days: params[:time].to_i).beginning_of_day
    @shifts = @employee.shifts.where("created_at > ?", start)
    @weekly_payrolls = @employee.weekly_payrolls.order("id DESC") #WeeklyPayroll.joins(:week).
    @active = params[:active]
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  #allows managers to update the details of other employees
  def update
    #authenticate admin
    @employee = Employee.find(params[:id])

    if @employee.update_attributes(update_params)
      flash[:success] = "successful update of employee"
      redirect_to admin_employee_path(@employee)
    else
      flash.now[:danger] = "employee update failed"
      render "edit"
    end
  end

  private
  #update strong params
  def update_params
    params.require(:employee).permit(:name, :wage, :position_id, :manager, :email, :password, :password_confirmation).reject{|k,v| v.blank?}
  end

  #verifys taht the password of the manager editing
  def verify_manager_password
    #verify managers password before allowing update 
    if !current_employee.valid_password?(params[:manager][:password])
      @employee = Employee.find(params[:id])
      flash.now[:danger] = "Incorrect manager password"
      render "edit"
    end
    
  end

end
