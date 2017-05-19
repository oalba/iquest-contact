class CustomersController < ApplicationController
  before_filter :authenticate_admin!, :except => [:edit, :update]
  def index
    @customers = Customer.order('created_at DESC').all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = Customer.find(params[:id])
    if !admin_signed_in? && @customer.locked == false
      @customer.increment!("opened_times", 1)
    end
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      flash[:success] = "Customer created successfully."
      redirect_to customers_path
    else
      flash[:error] = "Customer could not be created."
      render 'new'
    end
  end

  def update
    @customer = Customer.find(params[:id])

    if @customer.update(customer_params)
      flash[:success] = "Customer updated successfully."
      if admin_signed_in?
        redirect_to customers_path
      else
        @admins = Admin.all
        @admins.each do |admin|
          CustomerMailer.changes_email(@customer, admin).deliver
        end
        render 'thanks'
      end
    else
      flash[:error] = "Customer could not be updated."
      redirect_to edit_customer_path
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    if @customer.destroy
      flash[:success] = "Customer deleted successfully."
    else
      flash[:error] = "Customer could not be deleted."
    end
    redirect_to customers_path
  end

  def email
    @customer = Customer.find(params[:id])
    CustomerMailer.url_email(@customer).deliver
    redirect_to customers_path
  end

  private

    def customer_params
      params.require(:customer).permit(:name, :surname, :email, :phone, :comment, :locked, :url, :salutation, :company)
    end
end
