class SalesController < ApplicationController
  before_action :authenticate_employee_ajax!

  def create
    @employee = current_employee

    #if clocked in can create sale
    if @shift = @employee.current_shift

      @sale = Sale.new(sales_params)
      #wrap save in rescue to catch exceptions from callbacks that cause rollback
      begin
        #save (associations handled in callbacks) and pass alert to js.erb
        @sale.save!
        @alert = {type: "success", message: "Sale submitted"}

      rescue Exception => ex
        #pass failure alert
        @alert = {type: "danger", message: "Sale and tip creations failed: #{ex.message}"}
      end

    #if not clocked in, cant create sale
    else
      @alert = {type:"danger", message: "You are not clocked in. Clock in to make sale"}
    end
  end

  private

  #create sale stonr param 
  def sales_params
    params.require(:sale).permit(:method_of_payment, :price, :tip).merge(shift_id: @shift.id, created_at: Time.zone.now)
  end
end
