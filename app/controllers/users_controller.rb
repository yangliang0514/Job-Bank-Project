class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "註冊成功"
    else
      render :new
    end
  end

  def sign_in
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_conformation,
      :birthday,
      :gender,
    )
  end
end
