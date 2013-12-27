class UsersController < ApplicationController
  before_filter :set_user

  def change_password
  end

  def update_password
    unless @user.valid_password?(params[:user][:current_password])
      @user.errors.add :current_password, 'is invalid'
      render 'change_password'
      return
    end

    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path, alert: 'Password successfully changed'
    else
      render 'change_password'
    end
  end 

  def confirm_delete
  end

  def delete_user
    if @user.valid_password?(params[:current_password])
      @user.destroy
      sign_out
      redirect_to new_user_session_path, notice: 'Successfully removed your account'
    else
      @user.errors.add :password, 'is incorrect'
      render 'confirm_delete'
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
