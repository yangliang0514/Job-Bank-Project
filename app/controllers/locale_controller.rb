class LocaleController < ApplicationController
  def change
    if available_locale.include?(params[:lang])
      session[:locale] = params[:lang]
      redirect_to root_path
      return
    end

    record_not_found
  end

  private

  def available_locale
    %w[zh_tw ja]
  end
end
