class UsersController < ApplicationController
  def edit
    @user = current_user
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
