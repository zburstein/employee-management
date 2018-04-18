class Employees::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  skip_before_action :require_no_authentication, only: [:new, :create, :cancel]
  before_action :authenticate_manager, only: [:new, :create]

  # GET /resource/sign_up
  #def new
  #  super
  #end

  # POST /resource
  def create
    password = Devise.friendly_token.first(8)
    build_resource(sign_up_params.merge(password: password, password_confirmation: password))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        flash[:success] = "#{resource.name} successfully signed up"
        EmployeeMailer.registration_email(resource, password).deliver_now
        #set_flash_message! :notice, :signed_up
        #sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)
        redirect_to employees_dashboard_path
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, location: new_employee_registration_path
      #render "new"
      #redirect_to new_employee_registration_path(resource)
    end
  end


  # GET /resource/edit
  #def edit
  #  super
  #end

  # PUT /resource
  def update
    ####Ensure that if current employee is not manager, they cant edit anyone but themselves######
    super
  end

  # DELETE /resource
  def destroy
    redirect_to employees_dashboard_path
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :wage, :email, :position_id, :manager]) 
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    custom = current_employee.manager? ? [:name, :wage, :email, :position_id, :manager] : [:email]
    devise_parameter_sanitizer.permit(:account_update, keys: custom)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
