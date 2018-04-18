class Admin::SalesController < ApplicationController
  before_action :authenticate_manager
  def new
    #only allow on completed shifts??
    @sale = Sale.new
    @shift = Shift.find(params[:shift])
  end

  def create
    @shift = Shift.find(params[:sale][:shift_id])
    
    params[:sale][:created_at] = Time.zone.parse(@shift.created_at.strftime("%d/%m/%Y") + " " + params[:sale][:created_at])

    #Instantiate sale and remove empty value from associated_shifts_id
    @sale = Sale.new(sale_create_params)
    @sale.associated_shift_ids.reject!{|id| id.empty?}


    #wrap save in rescue to catch exceptions from callbacks that cause rollback
    begin
      #save (all associations dealt with in callbacks) and redirect
      @sale.save!
      flash[:success] = "Sale successfully created"
      redirect_to admin_shift_path @shift

    rescue Exception => ex
      #if exception called, render
      flash.now[:danger] = "Sale creation failed"
      render "new"
    end
  end

  def edit
    @sale = Sale.find(params[:id])
    @shift = @sale.shift
  end

  def update
    #find sale and assign attributes
    @sale = Sale.find(params[:id])
    @shift = @sale.shift
    
    params[:sale][:created_at] = Time.zone.parse(@shift.created_at.strftime("%d/%m/%Y") + " " + params[:sale][:created_at])

    @sale.assign_attributes(sale_update_params)
    @sale.new_associated_shift_ids.reject!{|id| id.empty?}
    #wrap save in rescue to catch exceptions from callbacks that cause rollback
    begin
      #save (all associations dealt with in callbacks) and redirect
      @sale.save!
      flash[:success] = "Sale and tips successfully updated"
      redirect_to admin_shift_path @shift

    rescue Exception => ex
      #if failed re render
      flash.now[:danger] = "Sale and tips failed to update"
      render "edit"
      
    end
  end

  def destroy
    sale = Sale.find(params[:id])
    shift = sale.shift

    #wrap save in rescue to catch exceptions from callbacks that cause rollback    
    begin
      #destroy (all associations dealt with in callbacks) and redirect
      sale.destroy
      flash[:success] = "Sale and its tips successdully destroyed"
      redirect_to admin_shift_path(shift)

    rescue Exception => ex
      #if failed re render
      flash.now[:danger] = "Sale failed to destroy: ex.message"
      render "show"
    end
  end

  private 
  #update strong params
  def sale_update_params
    params.require(:sale).permit(:method_of_payment, :price, :created_at, :tip, :new_associated_shift_ids => [])
  end

  #create strong params
  def sale_create_params
    params.require(:sale).permit(:method_of_payment, :price, :tip, :created_at, :shift_id, :associated_shift_ids => [])
  end
end
