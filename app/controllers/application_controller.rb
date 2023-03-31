class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  helper_method :user_signed_in?, :current_user

  private

  def user_signed_in?
    session[:_user_resume_dev_].present?
  end

  def current_user
    if user_signed_in?
      # 把找到的user存成instance variable，這樣下面也可以拿到，就不用需要時就一直往資料庫去找，叫memoization
      @_user ||= User.find_by(id: session[:_user_resume_dev_])
      return @_user
    end

    return nil
  end

  def authenticate_user!
    redirect_to sign_in_users_path unless user_signed_in?
  end

  def record_not_found
    render file: Rails.root.join("public", "404.html"),
           layout: false,
           status: 404 and return
  end
end
