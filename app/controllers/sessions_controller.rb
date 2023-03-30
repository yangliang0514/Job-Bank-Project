class SessionsController < ApplicationController
  def create
    user =
      User.login(
        email: params[:user][:email],
        password: params[:user][:password],
      )

    if user
      # 發session(做一個session在server中，同時發cookie給client)
      session[:_user_resume_dev_] = user.id

      redirect_to root_path, notice: "登入成功"
      return
    end

    redirect_to sign_in_users_path, alert: "登入失敗"
  end

  def destroy
    session[:_user_resume_dev_] = nil
    redirect_to root_path, notice: "已登出"
  end
end
