class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  def index
    @admins = Admin.order('created_at DESC').all
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.role_id = 1

    if @admin.save
      flash[:success] = "Admin created successfully."
      redirect_to admins_path
    else
      flash[:error] = "Admin could not be created."
      render 'new'
    end
  end

  def update
    @admin = Admin.find(params[:id])

    if admin_params[:password].blank?
      @admin.update_without_password(admin_params)
    else
      @admin.update_attributes(admin_params)
    end
    redirect_to admins_path
    # if @admin.update(admin_params)
    #   flash[:success] = "Admin updated successfully."
    #   redirect_to admin_path(@admin)
    # else
    #   flash[:error] = "Admin could not be updated."
    #   render 'edit'
    # end
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin.destroy
      flash[:success] = "Admin deleted successfully."
    else
      flash[:error] = "Admin could not be deleted."
    end
    redirect_to admins_path
  end

  private

    def admin_params
      params.require(:admin).permit(:name, :username, :email, :password, :password_confirmation)
    end
end
