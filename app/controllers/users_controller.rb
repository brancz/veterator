class UsersController < ApplicationController
  def change_password
    @user = User.find(current_user.id)
  end

  def update_password
    @user = User.find(current_user.id)

    unless @user.valid_password?(params[:user][:current_password])
      redirect_to change_password_users_path, alert: 'You must provide a valid current password'
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
    @user = User.find(current_user.id)
    if @user.valid_password?(params[:current_password])
      @user.destroy
      sign_out
      redirect_to new_user_session_path, notice: 'Successfully removed your account'
    else
      render 'confirm_delete'
    end
  end
end
