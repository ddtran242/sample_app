class UsersController < ApplicationController

  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :verify_admin, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "activation_account"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.order_microposts.paginate page: params[:page]
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success_updated_user"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "success_deleted_user"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:warning] = t "not_found_user"
      redirect_to root_path
    end
  end
end
