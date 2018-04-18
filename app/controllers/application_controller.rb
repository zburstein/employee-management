class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(employee)
    employees_dashboard_path
  end

  def after_sign_out_path(employee)
    root_path
  end

  def correct_employee?(intended_employee_id)
    if current_employee.id != intended_employee_id.to_i
      flash[:danger] = "Current User does not match source. Check who is logged in"
      sign_out(current_employee)  
      respond_to do |format|
        format.js { render :js => "window.location = '#{root_path}'"} 
        format.html { redirect_to root_path }
      end
    end
  end

  def authenticate_employee_ajax!
    if !employee_signed_in?
      flash[:danger] = "No one signed in. Please Sign in and try again"
      respond_to do |format|
        format.js { render :js => "window.location = '#{root_path}'"} 
        format.html { redirect_to root_path}
      end
    end
  end

  def authenticate_manager
    if !current_employee.try(:manager?) 
      flash[:danger] = "You are not authorized to access this"
      respond_to do |format|
        format.js { render :js => "window.location = '#{root_path}'"} 
        format.html { redirect_to root_path}
      end
    end
  end
end
