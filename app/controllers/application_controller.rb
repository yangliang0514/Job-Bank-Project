class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # 自動從session找有沒有設定語系，把語系改成設定的
  before_action :set_locale

  # this makes these methods avalible in all views
  helper_method :user_signed_in?, :current_user

  private

  # 如果使用者有設定語系，就用他的，不然就用default
  def set_locale
    locale = session[:locale] || I18n.default_locale
    I18n.locale = locale
  end

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
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def user_not_authorized
    flash[:alert] = "權限不足"
    redirect_back(fallback_location: root_path)
  end
end
