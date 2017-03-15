class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "info_password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_reset_password_failse"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("error_password_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t "success_reset_password"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    unless @user
      flash[:danger] = t "reset_password_not_valid"
      redirect_to root_url
    end
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      flash[:danger] = t "reset_password_not_valid"
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "password_reset_expired"
      redirect_to new_password_reset_url
    end
  end
end
