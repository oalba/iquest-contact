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
    unless customer_params[:file].blank?
      # Deleting previous files
      file1 = Rails.root.join("public/uploads/", params[:id] +'.*') 
      files1 = Dir.glob(file1) 
      files1.each do |f|
        File.delete(f)
      end
      # Uploading new file
      uploaded_io = customer_params.delete :file
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |files|
        files.write(uploaded_io.read)
        new_name = params[:id]
        # Renaming new file
        File.rename(files, "public/uploads/" + new_name + File.extname(files))
        new_file = params[:id] + File.extname(files)
        customer_params.merge!({file: new_file})
      end
    end

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
    File.delete('public/uploads/'+ @customer.file)
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
      @customer_params ||= params.require(:customer).permit(:name, :surname, :email, :phone, :comment, :locked, :url, :salutation, :company, :file)
    end
end
